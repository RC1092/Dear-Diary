import 'package:flutter/material.dart';

class customDec extends CustomPainter {
  double height;
  double width;

  customDec(this.height, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    final paintDarkgrey = Paint()
      ..color = Colors.blueGrey
      ..strokeWidth = 1.0;

    for (double i = 25; i < height; i += 25) {
      canvas.drawLine(Offset(0, i), Offset(width, i), paintDarkgrey);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
