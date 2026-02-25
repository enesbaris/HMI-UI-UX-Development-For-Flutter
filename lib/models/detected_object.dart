import 'package:flutter/material.dart';

class DetectedObject {
  final String label;
  final Rect box;
  final double confidence;
  final Color color;

  DetectedObject({
    required this.label,
    required this.box,
    required this.confidence,
    required this.color,
  });
}