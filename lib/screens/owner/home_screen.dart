import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String fullName;
  final String role;

  const HomeScreen({
    super.key,
    required this.fullName,
    required this.role
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Đăng nhập thành công!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Xin chào, $fullName',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(role),
              backgroundColor: Colors.deepPurple.shade100,
            ),
          ],
        ),
      ),
    );
  }
}