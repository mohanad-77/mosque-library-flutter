import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';

class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key, required this.labels, required this.icons, required this.current, required this.onChanged});
  final List<String> labels;
  final List<IconData> icons;
  final int current;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: warmSurface,
        border: Border(top: BorderSide(color: Color(0xFFE6E0CF))),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(child: InkWell(
              onTap: () => onChanged(i),
              child: Container(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                decoration: BoxDecoration(border: Border(top: BorderSide(
                  color: current == i ? gold : Colors.transparent, width: 2.5,
                ))),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(icons[i], size: 20, color: current == i ? darkGreen : const Color(0xFF89784F)),
                  const SizedBox(height: 2),
                  Text(labels[i], maxLines: 1, style: TextStyle(
                    color: current == i ? darkGreen : const Color(0xFF89784F),
                    fontSize: 11, fontWeight: current == i ? FontWeight.w800 : FontWeight.w500,
                  )),
                ]),
              ),
            )),
        ]),
      ),
    );
  }
}
