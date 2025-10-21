// lib/screens/user/orders_map_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/services/route_service.dart';

class OrdersMapScreen extends StatefulWidget {
  const OrdersMapScreen({super.key});

  @override
  State<OrdersMapScreen> createState() => _OrdersMapScreenState();
}

class _OrdersMapScreenState extends State<OrdersMapScreen> {
  final MapController _map = MapController();
  List<LatLng> _route = [];

  Future<void> _rebuildRoute(List<LatLng> pts) async {
    if (pts.length < 2) {
      setState(() => _route = []);
      return;
    }
    final svc = RouteService();
    final decoded = await svc.buildRoute(
      pts.map((e) => [e.latitude, e.longitude]).toList(),
    );
    setState(() => _route = decoded.map((e) => LatLng(e[0], e[1])).toList());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();
    final markers = <Marker>[];
    final pts = <LatLng>[];

    for (final o in prov.items) {
      if (o.lat != null && o.lng != null) {
        final p = LatLng(o.lat!, o.lng!);
        pts.add(p);
        markers.add(
          Marker(
            point: p,
            width: 220,
            height: 60,
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

    // Focus vào đơn được chọn
    final f = prov.focused;
    if (f != null && f.lat != null && f.lng != null) {
      Future.microtask(() {
        _map.move(LatLng(f.lat!, f.lng!), 14);
      });
    }

    // Vẽ tuyến
    _rebuildRoute(pts);

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
          subdomains: const ['a', 'b', 'c'],
          userAgentPackageName: 'frontend_nhom2',
          additionalOptions: const {
            'attribution': '© OpenStreetMap contributors',
          },
        ),
        PolylineLayer(
          polylines: [
            if (_route.isNotEmpty) Polyline(points: _route, strokeWidth: 4),
            if (_route.isEmpty && pts.length >= 2)
              Polyline(points: pts, strokeWidth: 2), // fallback: nối tuần tự
          ],
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
