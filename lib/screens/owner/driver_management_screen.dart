import 'package:flutter/material.dart';
import 'add_driver_screen.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {

  void _navigateToAddDriver() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDriverScreen()),
    );
    if (result == true) {
      // Sau này khi có danh sách, chúng ta sẽ refresh tại đây
      // setState(() { _loadDrivers(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Tài Xế'),
      ),
      body: const Center(
        // Sau này, đây sẽ là nơi hiển thị danh sách các tài xế
        child: Text('Chức năng hiển thị danh sách tài xế sẽ được cập nhật sau.'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDriver,
        tooltip: 'Thêm tài xế mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}