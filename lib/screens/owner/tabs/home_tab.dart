import 'package:flutter/material.dart';
import '../driver_management_screen.dart';
import '../vehicle_list_screen.dart';
// THÊM IMPORT MÀN HÌNH MỚI CHO CHỨC NĂNG QUẢN LÝ HÀNG HÓA
import 'goods_list_screen.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng Điều Khiển')),
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
                MaterialPageRoute(
                  builder: (context) => const VehicleListScreen(),
                ),
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
                MaterialPageRoute(
                  builder: (context) => const DriverManagementScreen(),
                ),
              );
            },
          ),
          // CẬP NHẬT ONTAP CHO QUẢN LÝ HÀNG HÓA
          _buildManagementCard(
            context: context,
            icon: Icons.inventory_2,
            title: 'Quản Lý Hàng Hóa',
            subtitle: 'Xem và quản lý kho hàng của bạn',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GoodsListScreen(),
                ),
              );
            },
          ),
          _buildManagementCard(
            context: context,
            icon: Icons.article,
            title: 'Quản Lý Đơn Hàng',
            subtitle: 'Tạo và theo dõi các đơn hàng',
            onTap: () {
              // TODO: Điều hướng tới Quản Lý Đơn Hàng
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 20.0,
        ),
        leading: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
