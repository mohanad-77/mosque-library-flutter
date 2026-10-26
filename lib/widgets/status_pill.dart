import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/models/library_book.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.text, this.background = softGreen, this.foreground = darkGreen});
  final String text;
  final Color background;
  final Color foreground;

  factory StatusPill.forBook(LibraryBook book) {
    if (book.availableCopies > 0) return const StatusPill(text: 'متاح ورقيًا');
    if (book.hasPdf) {
      return const StatusPill(text: 'إلكتروني · PDF', background: blueTint, foreground: Color(0xFF2D577D));
    }
    return const StatusPill(text: 'غير متاح حاليًا', background: bronzeTint, foreground: Color(0xFF846329));
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(text, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: foreground)),
      ),
    );
  }
}
