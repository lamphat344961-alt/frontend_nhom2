// lib/screens/user/orders_list_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/widgets/order_card.dart';
import 'package:provider/provider.dart';

class OrdersListScreen extends StatelessWidget {
  const OrdersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();
    return RefreshIndicator(
      onRefresh: () => context.read<OrdersProvider>().load(),
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
                  // gọi từ shell: setState -> index=1
                  // ở đây: dùng Navigator pop/push? Đơn giản: dùng Inherited callback
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
