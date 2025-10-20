import 'package:flutter/material.dart';
import 'package:frontend_nhom2/api/user_service.dart';
import 'package:frontend_nhom2/models/user_model.dart';
import 'add_driver_screen.dart';

class DriverManagementScreen extends StatefulWidget {
  const DriverManagementScreen({super.key});

  @override
  State<DriverManagementScreen> createState() => _DriverManagementScreenState();
}

class _DriverManagementScreenState extends State<DriverManagementScreen> {
  late Future<List<UserModel>> _driversFuture;
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadDrivers();
  }

  void _loadDrivers() {
    setState(() {
      _driversFuture = _userService.getDrivers();
    });
  }

  void _navigateToAddDriver() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDriverScreen()),
    );
    if (result == true) {
      // Tải lại danh sách nếu có tài xế mới được thêm
      _loadDrivers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Tài Xế'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<UserModel>>(
        future: _driversFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            // Hiển thị lỗi một cách thân thiện hơn
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Không thể tải dữ liệu. Vui lòng kiểm tra lại API endpoint.\nLỗi: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có tài xế nào được tạo.'));
          }

          final drivers = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: drivers.length,
            itemBuilder: (context, index) {
              final driver = drivers[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withAlpha(25),
                    child: Icon(Icons.person, color: Theme.of(context).primaryColor),
                  ),
                  title: Text(driver.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(driver.username),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    // TODO: Điều hướng đến màn hình chi tiết/sửa thông tin tài xế
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddDriver,
        tooltip: 'Thêm tài xế mới',
        child: const Icon(Icons.add),
      ),
    );
  }
}