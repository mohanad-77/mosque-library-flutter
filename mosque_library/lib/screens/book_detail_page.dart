import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/core/utils/show_note.dart';
import 'package:mosque_library/models/library_book.dart';
import 'package:mosque_library/widgets/book_cover.dart';
import 'package:mosque_library/widgets/green_button.dart';
import 'package:mosque_library/widgets/simple_header.dart';
import 'package:mosque_library/widgets/status_pill.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book});
  final LibraryBook book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Column(children: [
        SimpleHeader(
          title: 'تفاصيل الكتاب',
          subtitle: 'مكتبة مسجد الرحمة',
          trailing: IconButton(
            tooltip: 'رجوع',
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Expanded(child: ListView(padding: const EdgeInsets.fromLTRB(17, 24, 17, 25), children: [
          Center(child: BookCover(book: book, large: true)),
          const SizedBox(height: 19),
          Text(book.title, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: deepGreen)),
          const SizedBox(height: 5),
          Text(book.author, textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: muted)),
          const SizedBox(height: 12),
          Center(child: StatusPill.forBook(book)),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(color: warmSurface, borderRadius: BorderRadius.circular(15), border: Border.all(color: softBorder)),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(children: [
              _DetailLine(label: 'التصنيف', value: book.category),
              const Divider(color: softBorder, height: 1),
              _DetailLine(label: 'النسخ الورقية', value: book.hasPaper ? '${book.availableCopies} من ${book.totalCopies} متاحة' : 'غير متوفرة'),
              const Divider(color: softBorder, height: 1),
              _DetailLine(label: 'موقع الرف', value: book.hasPaper ? book.shelf : '—'),
              const Divider(color: softBorder, height: 1),
              _DetailLine(label: 'الكتاب الإلكتروني', value: book.hasPdf ? 'PDF · ${book.pdfSize}' : 'غير متوفر'),
            ]),
          ),
          const SizedBox(height: 20),
          const Text('للاستعارة الورقية، تواصل مع أمين مكتبة المسجد ليُسجل الإعارة باسم الكتاب.',
            style: TextStyle(fontSize: 12.5, height: 1.7, color: muted)),
          const SizedBox(height: 18),
          GreenButton(
            label: 'تنزيل الكتاب الإلكتروني',
            onPressed: book.hasPdf ? () => showNote(context, 'التنزيل يتطلب الربط بالخادم لاحقًا') : null,
          ),
          const SizedBox(height: 9),
          GreenButton(
            label: 'موقع النسخة الورقية', outline: true,
            onPressed: book.hasPaper ? () => showDialog<void>(
              context: context,
              builder: (dialogContext) => AlertDialog(
                title: const Text('مكان الكتاب'),
                content: Text('مكتبة مسجد الرحمة — الرف ${book.shelf}'),
                actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('إغلاق'))],
              ),
            ) : null,
          ),
        ])),
      ])),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(children: [
      Text(label, style: const TextStyle(color: muted, fontSize: 12.5)),
      const SizedBox(width: 8),
      Expanded(child: Text(value, textAlign: TextAlign.left,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5))),
    ]),
  );
}
