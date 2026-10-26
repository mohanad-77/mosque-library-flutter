import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/data/demo_library.dart';
import 'package:mosque_library/models/book_filter.dart';
import 'package:mosque_library/models/library_book.dart';
import 'package:mosque_library/screens/book_detail_page.dart';
import 'package:mosque_library/widgets/book_list_tile.dart';
import 'package:mosque_library/widgets/bottom_tabs.dart';
import 'package:mosque_library/widgets/green_button.dart';
import 'package:mosque_library/widgets/library_mark.dart';
import 'package:mosque_library/widgets/loan_card.dart';
import 'package:mosque_library/widgets/simple_header.dart';

class ReaderPage extends StatefulWidget {
  const ReaderPage({super.key, required this.library, required this.onLogout});
  final DemoLibrary library;
  final VoidCallback onLogout;

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  final searchController = TextEditingController();
  BookFilter filter = BookFilter.all;
  int tab = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<LibraryBook> get visibleBooks {
    final q = searchController.text.trim().toLowerCase();
    return widget.library.books.where((b) {
      if (filter == BookFilter.paper && !b.hasPaper) return false;
      if (filter == BookFilter.electronic && !b.hasPdf) return false;
      return b.title.toLowerCase().contains(q) || b.author.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        if (tab == 0) ...[
          _catalogHeader(),
          Expanded(child: _catalogBody()),
        ] else if (tab == 1)
          Expanded(child: _readerLoans())
        else
          Expanded(child: _accountPage()),
        BottomTabs(
          labels: const ['المكتبة', 'إعاراتي', 'حسابي'],
          icons: const [Icons.menu_book_outlined, Icons.receipt_long_outlined, Icons.person_outline],
          current: tab,
          onChanged: (i) => setState(() => tab = i),
        ),
      ])),
    );
  }

  Widget _catalogHeader() {
    return Container(
      color: darkGreen,
      child: GreenPattern(child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 19, 16, 15),
        child: Column(children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('السلام عليكم،', style: TextStyle(color: Color(0xFFF0ECDD), fontSize: 12)),
              SizedBox(height: 2),
              Text('خالد', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
            ])),
            IconButton(
              tooltip: 'حسابي',
              onPressed: () => setState(() => tab = 2),
              icon: const Icon(Icons.account_circle_outlined, color: Colors.white, size: 28),
            ),
          ]),
          const SizedBox(height: 15),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'ابحث بالعنوان أو المؤلف',
              prefixIcon: const Icon(Icons.search_rounded, color: muted),
              fillColor: warmSurface,
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(11)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(11)),
            ),
          ),
        ]),
      )),
    );
  }

  Widget _catalogBody() {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(14, 13, 14, 0),
        child: Row(children: [
          _filterChip('الكل', BookFilter.all),
          const SizedBox(width: 7),
          _filterChip('ورقي', BookFilter.paper),
          const SizedBox(width: 7),
          _filterChip('إلكتروني', BookFilter.electronic),
        ]),
      ),
      Expanded(child: visibleBooks.isEmpty
          ? const Center(child: Text('لا توجد كتب تطابق البحث', style: TextStyle(color: muted)))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(13, 12, 13, 22),
              itemCount: visibleBooks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final book = visibleBooks[i];
                return BookListTile(book: book, onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => BookDetailPage(book: book)));
                });
              },
            )),
    ]);
  }

  Widget _filterChip(String text, BookFilter value) {
    final selected = filter == value;
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      onSelected: (_) => setState(() => filter = value),
      showCheckmark: false,
      selectedColor: darkGreen,
      backgroundColor: warmSurface,
      side: BorderSide(color: selected ? darkGreen : const Color(0xFFBAAA7C)),
      labelStyle: TextStyle(color: selected ? Colors.white : const Color(0xFF7C6635), fontSize: 12, fontWeight: FontWeight.w700),
      shape: const StadiumBorder(),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _readerLoans() {
    final loans = widget.library.loans.where((l) => l.isActive && l.memberId == 'T-1025').toList();
    return Column(children: [
      const SimpleHeader(title: 'إعاراتي', subtitle: 'حساب المستفيد · T-1025'),
      Expanded(child: loans.isEmpty
        ? const Center(child: Text('لا توجد إعارات مسجلة لهذا المستفيد'))
        : ListView.separated(
            padding: const EdgeInsets.all(15),
            itemCount: loans.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => LoanCard(
              loan: loans[i], book: widget.library.bookById(loans[i].bookId),
            ),
          )),
    ]);
  }

  Widget _accountPage() {
    return Column(children: [
      const SimpleHeader(title: 'حسابي', subtitle: 'مكتبات المساجد'),
      Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(19), child: Column(children: [
        const SizedBox(height: 16),
        const LibraryMark(size: 72, circle: true),
        const SizedBox(height: 12),
        const Text('خالد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const Text('حساب المستفيد', style: TextStyle(fontSize: 12, color: muted)),
        const SizedBox(height: 25),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: warmSurface, border: Border.all(color: softBorder), borderRadius: BorderRadius.circular(15)),
          child: const Column(children: [
            _AccountLine(label: 'نوع الحساب', value: 'مستفيد'),
            Divider(color: softBorder),
            _AccountLine(label: 'المكتبة', value: 'مكتبة مسجد الرحمة'),
            Divider(color: softBorder),
            _AccountLine(label: 'حالة النظام', value: 'نموذج تجريبي'),
          ]),
        ),
        const SizedBox(height: 16),
        GreenButton(label: 'تسجيل الخروج', outline: true, onPressed: widget.onLogout),
      ]))),
    ]);
  }
}

class _AccountLine extends StatelessWidget {
  const _AccountLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(label, style: const TextStyle(color: muted, fontSize: 12)),
      const Spacer(),
      Flexible(child: Text(value, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12))),
    ]);
  }
}
