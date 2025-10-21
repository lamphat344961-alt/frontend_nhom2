// lib/screens/user/orders_list_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/widgets/order_card.dart';
import 'package:provider/provider.dart';
// THÊM: Import màn hình đăng nhập để điều hướng khi token hết hạn
import 'package:frontend_nhom2/screens/auth/login_screen.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();
    return RefreshIndicator(
      onRefresh: () async {
        try {
          // Thực hiện việc tải dữ liệu từ provider
          await context.read<OrdersProvider>().load();
        } catch (e) {
          final msg = e.toString();
          if (msg.contains('AUTH_401')) {
            // token hết hạn → về Login và xóa tất cả route cũ
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          } else if (msg.contains('AUTH_403')) {
            // Sai quyền (cần role Driver)
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Bạn không có quyền Driver để truy cập đơn hàng này',
                ),
              ),
            );
          } else {
            // Lỗi khác
            if (!context.mounted) return;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Lỗi tải đơn: $msg')));
          }
        }
      },
      child: prov.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: prov.items.length,
              itemBuilder: (c, i) => OrderCard(
                item: prov.items[i],
                onMapTap: () {
                  context.read<OrdersProvider>().focusOrder(
                    prov.items[i].maDon,
                  );
                  DefaultTabController.of(context);
                  // chuyển sang tab Map trong UserShell
                  // Giải pháp tối giản: dùng Notification để shell đổi tab
                  _SwitchToMapNotification().dispatch(context);
                },
              ),
            ),
    );
  }
}

// Thông báo để UserShell chuyển sang tab Map
class _SwitchToMapNotification extends Notification {}
