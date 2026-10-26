import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/models/library_book.dart';
import 'package:mosque_library/models/library_loan.dart';
import 'package:mosque_library/widgets/book_cover.dart';
import 'package:mosque_library/widgets/green_button.dart';
import 'package:mosque_library/widgets/status_pill.dart';

class LoanCard extends StatelessWidget {
  const LoanCard({super.key, required this.loan, required this.book, this.action});
  final LibraryLoan loan;
  final LibraryBook book;
  final VoidCallback? action;

  String dateText(DateTime d) => '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: warmSurface, borderRadius: BorderRadius.circular(15), border: Border.all(color: softBorder),
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BookCover(book: book, tiny: true),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(book.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 4),
          Text('${loan.memberName} · ${loan.memberId}', style: const TextStyle(color: muted, fontSize: 12)),
          Text('موعد الإرجاع: ${dateText(loan.dueAt)}', style: const TextStyle(color: muted, fontSize: 12)),
          const SizedBox(height: 7),
          loan.isOverdue
              ? const StatusPill(text: 'متأخرة', background: bronzeTint, foreground: Color(0xFF846329))
              : const StatusPill(text: 'نشطة'),
          if (action != null) ...[
            const SizedBox(height: 12),
            SizedBox(width: 150, child: GreenButton(label: 'تسجيل الإرجاع', outline: true, onPressed: action)),
          ],
        ])),
      ]),
    );
  }
}
