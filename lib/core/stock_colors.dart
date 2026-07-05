import 'package:flutter/material.dart';

class StockColors {
  const StockColors._();

  static const primary = Color(0xFF26379B);
  static const primaryLight = Color(0xFF3E63B9);
  static const green = Color(0xFF168E3B);
  static const red = Color(0xFFFF4B4B);
  static const muted = Color(0xFF65708F);
  static const scaffold = Color(0xFFF4F6FB);

  static Color fromHex(String hex) {
    final normalizedHex = hex.replaceFirst('#', '');
    final buffer = StringBuffer();

    if (normalizedHex.length == 6) {
      buffer.write('ff');
    }

    buffer.write(normalizedHex);

    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
