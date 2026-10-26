import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';

class GreenButton extends StatelessWidget {
  const GreenButton({super.key, required this.label, required this.onPressed, this.outline = false});
  final String label;
  final VoidCallback? onPressed;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: outline
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                shape: shape, foregroundColor: darkGreen,
                side: const BorderSide(color: gold),
              ),
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            )
          : FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: darkGreen, disabledBackgroundColor: const Color(0xFFB9C9BE),
                foregroundColor: Colors.white, shape: shape,
              ),
              child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
            ),
    );
  }
}
