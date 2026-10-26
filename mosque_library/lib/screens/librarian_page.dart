import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/core/utils/show_note.dart';
import 'package:mosque_library/data/demo_library.dart';
import 'package:mosque_library/models/library_book.dart';
import 'package:mosque_library/models/library_loan.dart';
import 'package:mosque_library/screens/librarian_books_page.dart';
import 'package:mosque_library/widgets/bottom_tabs.dart';
import 'package:mosque_library/widgets/book_cover.dart';
import 'package:mosque_library/widgets/green_button.dart';
import 'package:mosque_library/widgets/library_mark.dart';
import 'package:mosque_library/widgets/loan_card.dart';
import 'package:mosque_library/widgets/simple_header.dart';

class LibrarianPage extends StatefulWidget {
  const LibrarianPage({super.key, required this.library, required this.onLogout});
  final DemoLibrary library;
  final VoidCallback onLogout;

  @override
  State<LibrarianPage> createState() => _LibrarianPageState();
}

class _LibrarianPageState extends State<LibrarianPage> {
  final bookSearchController = TextEditingController();
  final memberController = TextEditingController(text: 'T-1025');
  final returnSearchController = TextEditingController();
  String? selectedBookId;
  int tab = 0;

  @override
  void dispose() {
    bookSearchController.dispose();
    memberController.dispose();
    returnSearchController.dispose();
    super.dispose();
  }

  LibraryBook? get selectedBook {
    for (final book in widget.library.books) {
      if (book.id == selectedBookId) return book;
    }
    return null;
  }

  List<LibraryBook> get matchingBooks {
    final query = bookSearchController.text.trim().toLowerCase();
    return widget.library.books.where((b) => b.hasPaper &&
        (query.isEmpty || b.title.toLowerCase().contains(query) || b.author.toLowerCase().contains(query))).toList();
  }

  void selectBook(LibraryBook book) => setState(() {
    selectedBookId = book.id;
    bookSearchController.text = book.title;
  });

  void confirmLoan() {
    final book = selectedBook;
    if (book == null) {
      showNote(context, 'اختر كتابًا من القائمة أولًا');
      return;
    }
    final error = widget.library.lend(bookId: book.id, memberId: memberController.text);
    if (error != null) {
      showNote(context, error);
      return;
    }
    setState(() {
      bookSearchController.clear();
      selectedBookId = null;
      tab = 1;
    });
    showNote(context, 'تم تسجيل إعارة «${book.title}» (تجريبيًا)');
  }

  Future<void> confirmReturn(LibraryLoan loan) async {
    final book = widget.library.bookById(loan.bookId);
    final allowed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('تأكيد إرجاع الكتاب'),
        content: Text('هل تم استلام «${book.title}» من ${loan.memberName}؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: const Text('إلغاء')),
          FilledButton(onPressed: () => Navigator.pop(dialogContext, true), child: const Text('تأكيد الإرجاع')),
        ],
      ),
    );
    if (!mounted || allowed != true) return;
    widget.library.returnCopy(loan);
    showNote(context, 'تم إرجاع «${book.title}» بنجاح (تجريبيًا)');
  }

  @override
  Widget build(BuildContext context) {
    const titles = ['إعارة كتاب', 'إرجاع الكتب', 'المتأخرات', 'حسابي'];
    return Scaffold(
      body: SafeArea(child: Column(children: [
        SimpleHeader(title: titles[tab], subtitle: 'أمين المكتبة · مسجد الرحمة'),
        Expanded(child: switch (tab) {
          0 => _lendingPage(),
          1 => _loanList(overdueOnly: false),
          2 => _loanList(overdueOnly: true),
          _ => _accountPage(),
        }),
        BottomTabs(
          labels: const ['إعارة', 'إرجاع', 'المتأخرات', 'حسابي'],
          icons: const [Icons.add_circle_outline_rounded, Icons.assignment_return_outlined, Icons.warning_amber_outlined, Icons.person_outline_rounded],
          current: tab, onChanged: (i) => setState(() => tab = i),
        ),
      ])),
    );
  }

  Widget _lendingPage() {
    final book = selectedBook;
    final memberName = DemoLibrary.members[memberController.text.trim().toUpperCase()];
    final canLend = book != null && book.availableCopies > 0 && memberName != null;

    return ListView(padding: const EdgeInsets.fromLTRB(14, 16, 14, 24), children: [
      const Text('1. اختر الكتاب باسمه', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      const SizedBox(height: 5),
      const Text('ابحث عن كتاب، ثم اختر النسخة المطلوبة.', style: TextStyle(color: muted, fontSize: 12)),
      const SizedBox(height: 10),
      TextField(
        controller: bookSearchController,
        onChanged: (_) => setState(() => selectedBookId = null),
        decoration: const InputDecoration(hintText: 'ابحث باسم الكتاب أو المؤلف', prefixIcon: Icon(Icons.search, color: muted)),
      ),
      const SizedBox(height: 11),
      if (book == null) ...[
        const Text('اختر كتابًا من نتائج البحث:', style: TextStyle(color: muted, fontSize: 11.5)),
        const SizedBox(height: 7),
        if (matchingBooks.isEmpty)
          const _SoftBox(child: Padding(padding: EdgeInsets.all(10), child: Text('لا توجد كتب ورقية تطابق البحث')))
        else
          for (final result in matchingBooks) ...[
            _BookChoice(
              book: result,
              onTap: result.availableCopies > 0 ? () => selectBook(result) : null,
            ),
            const SizedBox(height: 7),
          ],
      ] else
        _SoftBox(child: Row(children: [
          BookCover(book: book, tiny: true),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(book.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            Text('${book.author} · المتاح ${book.availableCopies} من ${book.totalCopies}',
                style: const TextStyle(color: muted, fontSize: 11)),
          ])),
          IconButton(
            tooltip: 'تغيير الكتاب',
            icon: const Icon(Icons.close, color: muted),
            onPressed: () => setState(() {
              selectedBookId = null;
              bookSearchController.clear();
            }),
          ),
        ])),
      if (book != null) ...[
        const SizedBox(height: 12),
        _SoftBox(
          background: softGreen,
          child: Text('الكتاب المحدد: ${book.title} · ${book.availableCopies} نسخة متاحة',
              style: const TextStyle(color: deepGreen, fontWeight: FontWeight.w700, fontSize: 12)),
        ),
      ],
      const SizedBox(height: 22),
      const Text('2. المستفيد', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
      const SizedBox(height: 9),
      const Text('رقم المستفيد', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      const SizedBox(height: 7),
      TextField(
        controller: memberController,
        textDirection: TextDirection.ltr,
        onChanged: (_) => setState(() {}),
        decoration: const InputDecoration(hintText: 'T-1025'),
      ),
      const SizedBox(height: 7),
      Text(memberName == null ? 'رقم المستفيد غير مسجل. جرّب T-1025' : 'المستفيد: $memberName',
          style: TextStyle(color: memberName == null ? const Color(0xFF996039) : muted, fontSize: 11.5)),
      const SizedBox(height: 17),
      const _SoftBox(background: Color(0xFFE7EEE5), child: Row(children: [
        Text('مدة الإعارة', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
        Spacer(),
        Text('14 يومًا', style: TextStyle(color: muted, fontSize: 12)),
      ])),
      const SizedBox(height: 13),
      GreenButton(label: 'تأكيد إعارة الكتاب', onPressed: canLend ? confirmLoan : null),
      const SizedBox(height: 9),
      const Center(child: Text('الإعارة تتم بالاسم، دون باركود. البيانات تجريبية.',
          textAlign: TextAlign.center, style: TextStyle(color: muted, fontSize: 11))),
    ]);
  }

  Widget _loanList({required bool overdueOnly}) {
    final q = returnSearchController.text.trim().toLowerCase();
    final all = widget.library.loans.where((loan) {
      if (!loan.isActive || (overdueOnly && !loan.isOverdue)) return false;
      final book = widget.library.bookById(loan.bookId);
      return q.isEmpty || book.title.toLowerCase().contains(q) ||
          loan.memberName.toLowerCase().contains(q) || loan.memberId.toLowerCase().contains(q);
    }).toList();
    final active = widget.library.loans.where((l) => l.isActive).length;
    final late = widget.library.loans.where((l) => l.isOverdue).length;

    return ListView(padding: const EdgeInsets.fromLTRB(14, 15, 14, 20), children: [
      Row(children: [
        Expanded(child: _StatBox(value: '$active', label: 'إعارات نشطة')),
        const SizedBox(width: 9),
        Expanded(child: _StatBox(value: '$late', label: 'إعارات متأخرة')),
      ]),
      const SizedBox(height: 15),
      if (!overdueOnly) ...[
        TextField(
          controller: returnSearchController,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'ابحث بالكتاب أو اسم المستفيد', prefixIcon: Icon(Icons.search, color: muted),
          ),
        ),
        const SizedBox(height: 15),
      ],
      Text(overdueOnly ? 'الكتب المتأخرة' : 'سجل الإعارات',
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      const SizedBox(height: 10),
      if (all.isEmpty)
        const _SoftBox(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24),
          child: Center(child: Text('لا توجد إعارات في هذا القسم', style: TextStyle(color: muted))),
        ))
      else
        for (final loan in all) ...[
          LoanCard(
            loan: loan,
            book: widget.library.bookById(loan.bookId),
            action: () => confirmReturn(loan),
          ),
          const SizedBox(height: 9),
        ],
    ]);
  }

  Widget _accountPage() {
    return ListView(padding: const EdgeInsets.all(17), children: [
      const SizedBox(height: 15),
      const Center(child: LibraryMark(size: 72, circle: true)),
      const SizedBox(height: 14),
      const Center(child: Text('أمين المكتبة', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800))),
      const Center(child: Text('مكتبة مسجد الرحمة', style: TextStyle(color: muted, fontSize: 12))),
      const SizedBox(height: 25),
      const _SoftBox(child: Column(children: [
        _AccountRow(label: 'نوع الحساب', value: 'أمين المكتبة'),
        Divider(color: softBorder),
        _AccountRow(label: 'المكتبة', value: 'مسجد الرحمة'),
        Divider(color: softBorder),
        _AccountRow(label: 'حالة النظام', value: 'نموذج تجريبي'),
      ])),
      const SizedBox(height: 17),
      GreenButton(
        label: 'عرض كتب المكتبة',
        onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => LibrarianBooksPage(library: widget.library))),
      ),
      const SizedBox(height: 9),
      GreenButton(label: 'تسجيل الخروج', outline: true, onPressed: widget.onLogout),
    ]);
  }
}

class _SoftBox extends StatelessWidget {
  const _SoftBox({required this.child, this.background = warmSurface});
  final Widget child;
  final Color background;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: background, border: Border.all(color: softBorder), borderRadius: BorderRadius.circular(13),
    ),
    child: child,
  );
}

class _BookChoice extends StatelessWidget {
  const _BookChoice({required this.book, required this.onTap});
  final LibraryBook book;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: warmSurface,
    borderRadius: BorderRadius.circular(13),
    child: InkWell(
      onTap: onTap, borderRadius: BorderRadius.circular(13),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), border: Border.all(color: softBorder)),
        child: Row(children: [
          BookCover(book: book, tiny: true),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(book.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
            Text('${book.author} · المتاح ${book.availableCopies} من ${book.totalCopies}',
                style: const TextStyle(color: muted, fontSize: 11)),
          ])),
          Icon(book.availableCopies > 0 ? Icons.check_circle_outline : Icons.block,
            color: book.availableCopies > 0 ? darkGreen : const Color(0xFF9C4E31), size: 19),
        ]),
      ),
    ),
  );
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(color: warmSurface, borderRadius: BorderRadius.circular(12), border: Border.all(color: softBorder)),
    child: Column(children: [
      Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: darkGreen)),
      Text(label, style: const TextStyle(color: muted, fontSize: 11)),
    ]),
  );
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => Row(children: [
    Text(label, style: const TextStyle(color: muted, fontSize: 12)),
    const Spacer(),
    Flexible(child: Text(value, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
  ]);
}
