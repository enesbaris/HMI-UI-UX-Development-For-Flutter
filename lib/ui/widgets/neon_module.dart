import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class NeonModule extends StatelessWidget {
  final String title;
  final Widget content;
  final Color color;
  final bool isLeft;
  final VoidCallback? onTap;

  const NeonModule({
    super.key, 
    required this.title, 
    required this.content, 
    required this.color, 
    this.isLeft = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform(
        transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateY(isLeft ? 0.08 : -0.08),
        child: Container(
          width: 280, height: 150,
          padding: const EdgeInsets.all(18),
          decoration: AppColors.cyberPanel(color),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
              const SizedBox(height: 8),
              content,
            ],
          ),
        ),
      ),
    );
  }
}