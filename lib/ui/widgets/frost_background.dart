import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class FrostBackground extends StatefulWidget {
  final bool isAutonomous;
  const FrostBackground({super.key, required this.isAutonomous});

  @override
  State<FrostBackground> createState() => _FrostBackgroundState();
}

class _FrostBackgroundState extends State<FrostBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = List.generate(35, (i) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) { p.update(); }
        return CustomPaint(
          painter: FrostPainter(_particles, widget.isAutonomous),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  double x = Random().nextDouble() * 1000;
  double y = Random().nextDouble() * 600;
  double speed = Random().nextDouble() * 1.5 + 0.2;
  void update() {
    y += speed;
    if (y > 600) { y = -10; x = Random().nextDouble() * 1000; }
  }
}

class FrostPainter extends CustomPainter {
  final List<Particle> particles;
  final bool isAuto;
  FrostPainter(this.particles, this.isAuto);

  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..shader = RadialGradient(
      center: Alignment.center,
      radius: 1.5,
      colors: [
        isAuto ? AppColors.cyanNeon.withValues(alpha: 0.1) : Colors.blue.withValues(alpha: 0.08),
        AppColors.background
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
    final pPaint = Paint()..color = Colors.white.withValues(alpha: 0.15);
    for (var p in particles) { canvas.drawCircle(Offset(p.x % size.width, p.y), 1.5, pPaint); }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}