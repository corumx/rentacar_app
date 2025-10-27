import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.indigo,
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
