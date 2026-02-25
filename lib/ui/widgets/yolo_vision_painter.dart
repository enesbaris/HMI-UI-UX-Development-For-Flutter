import 'package:flutter/material.dart';
import '../../models/detected_object.dart';

class YoloVisionPainter extends CustomPainter {
  final List<DetectedObject> detections;
  final bool isAuto;
  YoloVisionPainter(this.detections, this.isAuto);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = Colors.black.withValues(alpha: 0.6);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(10)), bgPaint);

    final lanePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    var path = Path()
      ..moveTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.45, size.height * 0.4)
      ..moveTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.55, size.height * 0.4);
    canvas.drawPath(path, lanePaint);

    for (var obj in detections) {
      final boxPaint = Paint()
        ..color = obj.color.withValues(alpha: 0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawRect(obj.box, boxPaint);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: "${obj.label} ${(obj.confidence * 100).toInt()}%",
          style: TextStyle(color: obj.color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(canvas, Offset(obj.box.left, obj.box.top - 15));
    }
  }

  @override
  bool shouldRepaint(covariant YoloVisionPainter oldDelegate) => true;
}