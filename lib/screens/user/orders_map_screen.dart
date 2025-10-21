import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';

class OrdersMapScreen extends StatefulWidget {
  const OrdersMapScreen({super.key});
  @override
  State<OrdersMapScreen> createState() => _OrdersMapScreenState();
}

class _OrdersMapScreenState extends State<OrdersMapScreen> {
  final _map = MapController();

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();
    final pts = <LatLng>[];
    final markers = <Marker>[];

    for (final o in prov.items) {
      if (o.lat != null && o.lng != null) {
        final p = LatLng(o.lat!, o.lng!);
        pts.add(p);
        markers.add(
          Marker(
            point: p,
            width: 40,
            height: 40,
            child: GestureDetector(
              onTap: () {
                final snack = SnackBar(
                  content: Text(
                    'Đơn ${o.maDon}\n${o.tenDiemGiao ?? ''}\n${o.diaChi ?? ''}',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snack);
              },
              child: const Icon(Icons.location_on, size: 36, color: Colors.red),
            ),
          ),
        );
      }
    }

    // focus khi chọn 1 đơn từ danh sách
    final f = prov.focused;
    if (f != null && f.lat != null && f.lng != null) {
      Future.microtask(() => _map.move(LatLng(f.lat!, f.lng!), 14));
    }

    return FlutterMap(
      mapController: _map,
      options: MapOptions(
        initialCenter: pts.isNotEmpty
            ? pts.first
            : const LatLng(10.7769, 106.7009),
        initialZoom: 12,
      ),
      children: [
        TileLayer(
          urlTemplate: Env.OSM_TILE_URL,
          userAgentPackageName: 'frontend_nhom2',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
