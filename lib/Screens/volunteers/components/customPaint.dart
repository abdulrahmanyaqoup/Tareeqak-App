import 'package:flutter/material.dart';

class CustomIconsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 56, 53, 63)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    canvas.drawCircle(Offset((size.width / 30) + (size.width / 1000), (size.height / 2) + 70), 70, paint);
    canvas.drawCircle(Offset((size.width / 2) + (size.width / 1000), (size.height / 2) + 70), 30, paint);
    canvas.drawCircle(Offset((size.width / 1.2) + (size.width / 1000), (size.height / 2) + 70), 30, paint);
    canvas.drawCircle(Offset((size.width / 1.5) + (size.width / 1000), (size.height / 2) + 70), 30, paint);
    canvas.drawCircle(Offset((size.width / 1.5) + (size.width / 1000), (size.height / 2) + 70), 70, paint);
    canvas.drawCircle(Offset((size.width / 1.5) + (size.width / 1000), (size.height / 2) + 70), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
