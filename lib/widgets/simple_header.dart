import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';
import 'package:mosque_library/widgets/library_mark.dart';

class SimpleHeader extends StatelessWidget {
  const SimpleHeader({super.key, required this.title, required this.subtitle, this.trailing});
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: darkGreen, border: Border(bottom: BorderSide(color: softGold, width: 3)),
      ),
      child: GreenPattern(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(17, 20, 17, 18),
          child: Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(subtitle, style: const TextStyle(color: Color(0xFFE7E5D9), fontSize: 12)),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
            ])),
            if (trailing != null) trailing!,
          ]),
        ),
      ),
    );
  }
}
