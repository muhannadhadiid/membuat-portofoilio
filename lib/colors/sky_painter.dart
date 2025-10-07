import 'dart:math';
import 'package:flutter/material.dart';

class SkyPainter extends CustomPainter {
  final double progress;
  SkyPainter(this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final t = (progress * 2) % 1;
    final Gradient skyGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color.lerp(Colors.blue, Colors.orange, t)!,
        Color.lerp(Colors.lightBlue.shade100, Colors.purple, t)!,
      ],
    );
    final Paint bgPaint = Paint()
      ..shader = skyGradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    final sunX = size.width * progress;
    final sunY = size.height * 0.3 + sin(progress * 2 * pi) * 50;
    final sunPaint = Paint()..color = Colors.yellow;
    canvas.drawCircle(Offset(sunX, sunY), 40, sunPaint);
    final cloudPaint = Paint()..color = Colors.white.withOpacity(0.8);
    for (int i = 0; i < 3; i++) {
      final cloudX = (size.width * (progress + i * 0.3)) % size.width;
      final cloudY = size.height * 0.15 + i * 40;
      _drawCloud(canvas, cloudX, cloudY, cloudPaint);
    }
  }

  void _drawCloud(Canvas canvas, double x, double y, Paint paint) {
    canvas.drawCircle(Offset(x, y), 20, paint);
    canvas.drawCircle(Offset(x + 25, y + 5), 25, paint);
    canvas.drawCircle(Offset(x - 25, y + 5), 25, paint);
    canvas.drawCircle(Offset(x, y + 15), 22, paint);
  }

  @override
  bool shouldRepaint(covariant SkyPainter oldDelegate) => true;
}
