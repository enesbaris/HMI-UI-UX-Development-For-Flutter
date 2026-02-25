import 'package:flutter/material.dart';

class HyperSpeedo extends StatelessWidget {
  final double speed;
  final Color color;

  const HyperSpeedo({super.key, required this.speed, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.topCenter, end: Alignment.bottomCenter,
            colors: [Colors.white, color.withValues(alpha: 0.5)],
          ).createShader(bounds),
          child: Text(
            "${speed.toInt()}",
            style: TextStyle(
              fontSize: 180, 
              fontWeight: FontWeight.w900, 
              height: 0.85, 
              letterSpacing: -8,
              shadows: [
                Shadow(color: color.withValues(alpha: 0.8), blurRadius: 40),
                Shadow(color: color.withValues(alpha: 0.4), blurRadius: 80),
              ],
            ),
          ),
        ),
        Text(
          "KM/H", 
          style: TextStyle(
            color: color.withValues(alpha: 0.6), 
            letterSpacing: 12, 
            fontWeight: FontWeight.bold, 
            fontSize: 22
          )
        ),
      ],
    );
  }
}