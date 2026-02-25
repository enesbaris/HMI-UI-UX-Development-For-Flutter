import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class LidarPulse extends StatefulWidget {
  const LidarPulse({super.key});
  @override
  State<LidarPulse> createState() => _LidarPulseState();
}

class _LidarPulseState extends State<LidarPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: LidarWavePainter(_controller.value),
          size: const Size(120, 100),
        );
      },
    );
  }
}

class LidarWavePainter extends CustomPainter {
  final double progress;
  LidarWavePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.cyanNeon.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 3; i++) {
      double currentProgress = (progress + (i * 0.33)) % 1.0;
      double radius = size.width * 0.5 * currentProgress;
      double opacity = 1.0 - currentProgress;
      
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        radius,
        paint..color = AppColors.cyanNeon.withValues(alpha: opacity * 0.5),
      );
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class CanDataStream extends StatelessWidget {
  const CanDataStream({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) => Container(
          width: 4, height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: AppColors.blueNeon.withValues(alpha: (i % 5 == 0) ? 0.8 : 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}