import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';

class OrdersListScreen extends StatelessWidget {
  final VoidCallback? onSelectToMap;
  const OrdersListScreen({super.key, this.onSelectToMap});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();

    Widget body() {
      switch (prov.state) {
        case OrdersState.loading:
          return const Center(child: CircularProgressIndicator());
        case OrdersState.error:
          return Center(child: Text('Lỗi: ${prov.error}'));
        case OrdersState.loaded:
          if (prov.items.isEmpty) {
            return const Center(child: Text('Chưa có đơn giao'));
          }
          return RefreshIndicator(
            onRefresh: prov.refresh,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: prov.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final o = prov.items[i];
                return _OrderTile(
                  item: o,
                  onTap: () {
                    prov.focusOrder(o.maDon);
                    onSelectToMap?.call(); // chuyển sang tab Map
                  },
                );
              },
            ),
          );
        default:
          return const SizedBox();
      }
    }

    return Scaffold(body: body());
  }
}

class _OrderTile extends StatelessWidget {
  final DonHangItem item;
  final VoidCallback onTap;
  const _OrderTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (item.tenDiemGiao?.isNotEmpty == true) item.tenDiemGiao,
      if (item.diaChi?.isNotEmpty == true) item.diaChi,
      if (item.trangThai?.isNotEmpty == true) 'Trạng thái: ${item.trangThai}',
    ].whereType<String>().join(' · ');

    return ListTile(
      leading: const Icon(Icons.assignment_outlined),
      title: Text('Đơn: ${item.maDon}'),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
