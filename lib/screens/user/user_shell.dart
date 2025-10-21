import 'package:flutter/material.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/screens/user/orders_list_screen.dart';
import 'package:frontend_nhom2/screens/user/orders_map_screen.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/providers/auth_provider.dart';
// THÊM: Import màn hình Login để điều hướng về sau khi logout
import 'package:frontend_nhom2/screens/auth/login_screen.dart';

class UserShell extends StatefulWidget {
  const UserShell({super.key});
  @override
  State<UserShell> createState() => _UserShellState();
}

class _UserShellState extends State<UserShell> {
  int _idx = 0;

  @override
  void initState() {
    super.initState();
    // load data ngay khi vào
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrdersProvider>().load();
    });
  }

  // TÁCH HÀM: Tách logic logout ra một hàm riêng cho rõ ràng
  Future<void> _logout() async {
    // Gọi hàm logout từ AuthProvider để xóa token
    await context.read<AuthProvider>().logout();

    // Kiểm tra xem widget còn tồn tại không trước khi điều hướng
    if (mounted) {
      // SỬA ĐỔI QUAN TRỌNG: Điều hướng dứt khoát về màn hình Login
      // Cách này sẽ xóa toàn bộ các màn hình cũ và thay thế bằng LoginScreen,
      // đảm bảo người dùng không thể "back" lại màn hình cũ.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Xóa tất cả các route trước đó
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Danh sách các màn hình tương ứng với các tab
    final tabs = <Widget>[
      const OrdersListScreen(),
      const OrdersMapScreen(),
      // Giữ placeholder vì logic logout được xử lý ở onDestinationSelected
      const SizedBox.shrink(),
      const _SupportPlaceholder(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Giao hàng - User')),
      body: tabs[_idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list_alt), label: 'List'),
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.logout), label: 'Logout'),
          NavigationDestination(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
        onDestinationSelected: (i) {
          // Khi người dùng chọn tab thứ 3 (index = 2)
          if (i == 2) {
            // Gọi hàm logout đã tách ra
            _logout();
          } else {
            // Nếu chọn các tab khác, cập nhật lại state để đổi màn hình
            setState(() => _idx = i);
          }
        },
      ),
    );
  }
}

class _SupportPlaceholder extends StatelessWidget {
  const _SupportPlaceholder();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Coming soon'));
  }
}
