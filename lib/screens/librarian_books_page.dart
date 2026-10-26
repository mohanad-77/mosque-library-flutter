import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/data/demo_library.dart';
import 'package:mosque_library/screens/book_detail_page.dart';
import 'package:mosque_library/widgets/book_list_tile.dart';

class LibrarianBooksPage extends StatelessWidget {
  const LibrarianBooksPage({super.key, required this.library});
  final DemoLibrary library;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('كتب المكتبة')),
    body: ListView.separated(
      padding: const EdgeInsets.all(14),
      itemCount: library.books.length,
      separatorBuilder: (_, __) => const SizedBox(height: 9),
      itemBuilder: (_, i) {
        final book = library.books[i];
        return BookListTile(book: book, onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
        ));
      },
    ),
  );
}
