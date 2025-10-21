// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

ThemeData appTheme() => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
  useMaterial3: true,
  fontFamily: 'Roboto',
);
