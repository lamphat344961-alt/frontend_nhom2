import 'package:flutter/material.dart';
import 'package:frontend_nhom2/screens/auth/login_screen.dart';
import 'package:frontend_nhom2/screens/owner/driver_management_screen.dart';
import 'package:frontend_nhom2/screens/owner/vehicle_list_screen.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  State<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  String _fullName = 'Owner';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final fullName = await TokenManager.getFullName();
    if (fullName != null) {
      setState(() {
        _fullName = fullName;
      });
    }
  }

  void _logout() async {
    await TokenManager.clearAll();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chào mừng, $_fullName'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: _logout,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildManagementCard(
            context: context,
            icon: Icons.directions_car,
            title: 'Quản Lý Xe',
            subtitle: 'Thêm, sửa, xóa và gán tài xế cho xe',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VehicleListScreen()),
              );
            },
          ),
          _buildManagementCard(
            context: context,
            icon: Icons.person_add,
            title: 'Quản Lý Tài Xế',
            subtitle: 'Tạo tài khoản mới cho tài xế',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DriverManagementScreen()),
              );
            },
          ),
          _buildManagementCard(
            context: context,
            icon: Icons.inventory_2,
            title: 'Quản Lý Hàng Hóa',
            subtitle: 'Xem và quản lý kho hàng của bạn',
            onTap: () {
              // TODO: Điều hướng đến màn hình quản lý hàng hóa
            },
          ),
          _buildManagementCard(
            context: context,
            icon: Icons.article,
            title: 'Quản Lý Đơn Hàng',
            subtitle: 'Tạo và theo dõi các đơn hàng',
            onTap: () {
              // TODO: Điều hướng đến màn hình quản lý đơn hàng
            },
          ),
          _buildManagementCard(
            context: context,
            icon: Icons.bar_chart,
            title: 'Thống Kê',
            subtitle: 'Xem báo cáo và hiệu suất kinh doanh',
            onTap: () {
              // TODO: Điều hướng đến màn hình thống kê
            },
          ),
        ],
      ),
    );
  }

  Widget _buildManagementCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}