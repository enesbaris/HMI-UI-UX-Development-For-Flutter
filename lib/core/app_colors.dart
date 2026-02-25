import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF010203);
  static const Color panelBg = Color(0xFF050A0F);
  static const Color cyanNeon = Color(0xFF00FFF2);
  static const Color blueNeon = Color(0xFF0066FF);
  static const Color redNeon = Color(0xFFFF0055);
  static const Color energyGreen = Color(0xFF39FF14);
  static const Color iceBlue = Color(0xFFA5D7E8);

  static List<BoxShadow> proGlow(Color color) => [
    BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 20, spreadRadius: 1),
    BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 45, spreadRadius: 5),
  ];

  static BoxDecoration cyberPanel(Color color) => BoxDecoration(
    color: panelBg.withValues(alpha: 0.8),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
    boxShadow: [
      BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5)
    ],
  );

  static BoxDecoration glassDecoration = BoxDecoration(
    color: Colors.white.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(30),
    border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1.5),
  );
}