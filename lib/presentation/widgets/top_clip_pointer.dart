import 'package:flutter/material.dart';
import 'package:self_management/common/app_color.dart';

class TopClipPointer extends StatelessWidget {
  const TopClipPointer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(190, 350),
      painter: _ClipPainter(),
    );
  }
}

class _ClipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    Path path = Path();

    // Path number 1

    paint.color = AppColor.primary;
    path = Path();
    path.lineTo(size.width * 0.32, size.height * 0.45);
    path.cubicTo(-0.06, size.height * 0.27, -0.01, size.height * 0.1,
        size.width * 0.02, 0);
    path.cubicTo(size.width * 0.02, 0, size.width, 0, size.width, 0);
    path.cubicTo(
        size.width, 0, size.width, size.height, size.width, size.height);
    path.cubicTo(size.width * 0.76, size.height * 1.02, size.width * 0.68,
        size.height * 0.86, size.width * 0.69, size.height * 0.79);
    path.cubicTo(size.width * 0.75, size.height * 0.58, size.width * 0.42,
        size.height / 2, size.width * 0.32, size.height * 0.45);
    path.cubicTo(size.width * 0.32, size.height * 0.45, size.width * 0.32,
        size.height * 0.45, size.width * 0.32, size.height * 0.45);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
