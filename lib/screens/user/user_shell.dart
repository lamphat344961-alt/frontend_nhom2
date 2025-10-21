import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/screens/user/orders_list_screen.dart';
import 'package:frontend_nhom2/screens/user/orders_map_screen.dart';
import 'package:frontend_nhom2/providers/auth_provider.dart';
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
    // nạp danh sách đơn ngay khi mở shell
    Future.microtask(() => context.read<OrdersProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final tabs = <Widget>[
      OrdersListScreen(onSelectToMap: () => setState(() => _idx = 1)),
      const OrdersMapScreen(),
      const SizedBox.shrink(), // placeholder cho Logout
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
        onDestinationSelected: (i) async {
          if (i == 2) {
            // Logout
            await context.read<AuthProvider>().logout();
            if (!mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          } else {
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
  Widget build(BuildContext context) =>
      const Center(child: Text('Coming soon'));
}
