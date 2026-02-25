import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class TurnSignal extends StatelessWidget {
  final bool isLeft;
  final bool active;

  const TurnSignal({super.key, required this.isLeft, required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.energyGreen : Colors.white.withValues(alpha: 0.05);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          isLeft ? "SOL SİNYAL" : "SAĞ SİNYAL",
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            shadows: active ? AppColors.proGlow(AppColors.energyGreen) : [],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Opacity(
              opacity: active ? (1.0 - (index * 0.2)) : 0.1,
              child: Icon(
                isLeft ? Icons.chevron_left : Icons.chevron_right,
                color: color,
                size: 32,
                shadows: active ? AppColors.proGlow(AppColors.energyGreen) : [],
              ),
            );
          }),
        ),
      ],
    );
  }
}