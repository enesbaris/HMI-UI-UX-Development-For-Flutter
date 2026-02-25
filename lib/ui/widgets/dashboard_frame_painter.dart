import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class DashboardFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [AppColors.cyanNeon.withValues(alpha: 0.3), AppColors.blueNeon.withValues(alpha: 0.1)],
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    Path path = Path();
    path.moveTo(0, size.height * 0.4);
    path.lineTo(size.width * 0.1, size.height * 0.05);
    path.lineTo(size.width * 0.35, 0);
    path.lineTo(size.width * 0.45, size.height * 0.1);
    path.lineTo(size.width * 0.55, size.height * 0.1);
    path.lineTo(size.width * 0.65, 0);
    path.lineTo(size.width * 0.9, size.height * 0.05);
    path.lineTo(size.width, size.height * 0.4);
    path.lineTo(size.width * 0.92, size.height * 0.95);
    path.lineTo(size.width * 0.08, size.height * 0.95);
    path.close();

    canvas.drawPath(path, paint);
    
    // Alt Glow Hattı
    canvas.drawPath(path, Paint()
      ..color = AppColors.cyanNeon.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}