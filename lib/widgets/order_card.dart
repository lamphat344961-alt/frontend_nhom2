// lib/widgets/order_card.dart
import 'package:flutter/material.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';

class OrderCard extends StatelessWidget {
  final DonHangItem item;
  final VoidCallback onMapTap;
  const OrderCard({super.key, required this.item, required this.onMapTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã đơn: ${item.maDon}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (item.tenDiemGiao != null)
              Text('Người nhận: ${item.tenDiemGiao}'),
            if (item.diaChi != null) Text('Địa chỉ: ${item.diaChi}'),
            if (item.trangThai != null) Text('Trạng thái: ${item.trangThai}'),
            const SizedBox(height: 8),
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onMapTap,
                  icon: const Icon(Icons.map),
                  label: const Text('Xem bản đồ'),
                ),
                const SizedBox(width: 8),
                if (item.lat == null || item.lng == null)
                  const Text(
                    'Thiếu toạ độ',
                    style: TextStyle(color: Colors.orange),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
