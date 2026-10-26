import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/models/library_book.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book, this.large = false, this.tiny = false});
  final LibraryBook book;
  final bool large;
  final bool tiny;

  @override
  Widget build(BuildContext context) {
    final width = large ? 124.0 : tiny ? 38.0 : 68.0;
    final height = large ? 160.0 : tiny ? 49.0 : 89.0;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF216344), Color(0xFF063B2B)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(large ? 12 : 8),
        border: Border.all(color: softGold, width: 0.8),
        boxShadow: const [BoxShadow(color: Color(0x1D172B21), blurRadius: 7, offset: Offset(2, 4))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(right: 4, top: 4, bottom: 4, child: Container(width: large ? 5 : 3, color: const Color(0x55051F16))),
          Icon(Icons.auto_stories_rounded, size: large ? 67 : tiny ? 22 : 38, color: softGold),
          Positioned(bottom: 0, left: 0, right: 0, child: Container(height: large ? 5 : 3, color: gold.withOpacity(0.8))),
        ],
      ),
    );
  }
}
