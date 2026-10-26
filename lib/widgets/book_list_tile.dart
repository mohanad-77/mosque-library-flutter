import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/models/library_book.dart';
import 'package:mosque_library/widgets/book_cover.dart';
import 'package:mosque_library/widgets/status_pill.dart';

class BookListTile extends StatelessWidget {
  const BookListTile({super.key, required this.book, required this.onTap});
  final LibraryBook book;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: warmSurface,
      elevation: 1.2,
      shadowColor: const Color(0x261C241C),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: softBorder), borderRadius: BorderRadius.circular(16)),
          child: Row(children: [
            BookCover(book: book),
            const SizedBox(width: 13),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.25)),
              const SizedBox(height: 3),
              Text(book.author, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: muted, fontSize: 12)),
              const SizedBox(height: 8),
              StatusPill.forBook(book),
            ])),
            const SizedBox(width: 3),
            const Icon(Icons.chevron_left_rounded, color: muted, size: 19),
          ]),
        ),
      ),
    );
  }
}
