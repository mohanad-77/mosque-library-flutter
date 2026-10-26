import 'package:flutter/material.dart';
import 'package:mosque_library/core/theme/app_colors.dart';

/// علامة مكتبات المساجد (قوس بسيط فوق كتاب) دون الحاجة إلى ملفات صور.
class LibraryMark extends StatelessWidget {
  const LibraryMark({super.key, this.size = 100, this.circle = false});
  final double size;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: Size.square(size),
      painter: _ArchPainter(),
      child: SizedBox.square(
        dimension: size,
        child: Align(
          alignment: const Alignment(0, 0.51),
          child: Icon(Icons.auto_stories_rounded, size: size * 0.53, color: softGold),
        ),
      ),
    );
    if (!circle) return mark;
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(color: gold, shape: BoxShape.circle),
      padding: EdgeInsets.all(size * 0.17),
      child: Icon(Icons.auto_stories_rounded, color: deepGreen, size: size * 0.54),
    );
  }
}

class _ArchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final p = Paint()
      ..color = const Color(0xFFFFF8E7)
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(w * 0.29, h * 0.51)
      ..lineTo(w * 0.29, h * 0.32)
      ..quadraticBezierTo(w * 0.35, h * 0.24, w * 0.50, h * 0.18)
      ..quadraticBezierTo(w * 0.65, h * 0.24, w * 0.71, h * 0.32)
      ..lineTo(w * 0.71, h * 0.51);
    canvas.drawPath(path, p);
    final peak = Path()
      ..moveTo(w * 0.50, h * 0.18)
      ..lineTo(w * 0.50, h * 0.10);
    canvas.drawPath(peak, p..color = softGold);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// زخرفة خفيفة مستوحاة من هندسة غلاف HTML، غير تفاعلية.
class GreenPattern extends StatelessWidget {
  const GreenPattern({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      const Positioned.fill(child: CustomPaint(painter: _GeometricPainter())),
      child,
    ],
  );
}

class _GeometricPainter extends CustomPainter {
  const _GeometricPainter();
  @override
  void paint(Canvas canvas, Size s) {
    final p = Paint()
      ..color = const Color(0x1AD1BA73)
      ..strokeWidth = 0.75
      ..style = PaintingStyle.stroke;
    const step = 36.0;
    for (double x = -s.height; x < s.width + s.height; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x + s.height, s.height), p);
      canvas.drawLine(Offset(x, 0), Offset(x - s.height, s.height), p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
