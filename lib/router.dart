// lib/router.dart
import 'package:flutter/material.dart';
import 'package:frontend_nhom2/screens/auth/login_screen.dart';
import 'package:frontend_nhom2/screens/auth/register_screen.dart';
import 'package:frontend_nhom2/screens/user/user_shell.dart';
import 'package:frontend_nhom2/screens/owner/owner_dashboard_screen.dart';

class AppRoutes {
  static Widget ownerHome() => const OwnerDashboardScreen();
  static Widget userHome() => const UserShell();
  static Widget login() => const LoginScreen();
  static Widget register() => const RegisterScreen();
}
