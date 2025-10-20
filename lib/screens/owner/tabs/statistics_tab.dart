import 'package:flutter/material.dart';

class StatisticsTab extends StatelessWidget {
  const StatisticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thống Kê'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            const Text(
              'Biểu đồ thống kê sẽ được hiển thị ở đây.',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}