<<<<<<< HEAD
// lib/screens/orders_map_screen.dart (ý chính)
=======
>>>>>>> 3ae696c0b5147b44fc64b4b51a8e18fa5d6b8053
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';

class OrdersMapScreen extends StatefulWidget {
  const OrdersMapScreen({super.key});
  @override
  State<OrdersMapScreen> createState() => _OrdersMapScreenState();
}

class _OrdersMapScreenState extends State<OrdersMapScreen> {
<<<<<<< HEAD
  final _mapController = MapController();
  List<LatLng> _route = [];
  List<LatLng> _markers = [];
  double _distanceM = 0;
  double _durationS = 0;
  List<dynamic> _legs = [];

  Future<void> _optimizeAndDraw() async {
    final prov = context.read<OrdersProvider>();
    final pts = prov.items
        .where((o) => o.lat != null && o.lng != null)
        .map((o) => [o.lat!, o.lng!])
        .toList();

    if (pts.length < 2) {
      setState(() {
        _route = [];
        _markers = pts.map((e) => LatLng(e[0], e[1])).toList();
        _distanceM = 0;
        _durationS = 0;
        _legs = [];
      });
      return;
    }

    final svc = RouteService();
    final res = await svc.optimizeTrip(pts);

    final decoded = (res['polyline'] as List)
        .map<LatLng>((e) => LatLng(e[0] as double, e[1] as double))
        .toList();

    final order = (res['order'] as List).map((e) => e as int).toList();
    final reorderedPts = order.map((i) => pts[i]).toList();

    setState(() {
      _route = decoded;
      _markers = reorderedPts.map((p) => LatLng(p[0], p[1])).toList();
      _distanceM = (res['distance'] as num).toDouble();
      _durationS = (res['duration'] as num).toDouble();
      _legs = (res['legs'] as List);
    });

    // Fit bounds
    final bounds = LatLngBounds(
      _markers.first,
      _markers.first,
    ); // tạo bounds rỗng
    for (final p in _markers) bounds.extend(p); // thêm từng điểm vào bounds

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(32)),
    );
  }

  // Hiển thị steps đơn giản từ legs
  void _showStepsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        final tiles = <Widget>[];
        int legIdx = 0;
        for (final leg in _legs) {
          final steps = (leg['steps'] as List?) ?? [];
          tiles.add(
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Chặng ${++legIdx}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
          for (final s in steps) {
            final name = s['name'] ?? '';
            final instruction =
                (s['maneuver']?['instruction']) ?? s['maneuver']?['type'] ?? '';
            final dist = (s['distance'] as num?)?.toStringAsFixed(0) ?? '0';
            tiles.add(
              ListTile(
                dense: true,
                leading: const Icon(Icons.turn_right),
                title: Text(instruction.toString()),
                subtitle: Text('$name • ${dist}m'),
              ),
            );
          }
          tiles.add(const Divider(height: 1));
        }
        if (tiles.isEmpty)
          tiles.add(const ListTile(title: Text('Không có chỉ dẫn.')));
        return SafeArea(child: ListView(children: tiles));
      },
    );
  }
=======
  final _map = MapController();
>>>>>>> 3ae696c0b5147b44fc64b4b51a8e18fa5d6b8053

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<OrdersProvider>();
<<<<<<< HEAD
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ giao hàng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.route),
            tooltip: 'Sắp xếp tối ưu',
            onPressed: _optimizeAndDraw,
          ),
          IconButton(
            icon: const Icon(Icons.directions),
            tooltip: 'Xem chỉ dẫn',
            onPressed: _legs.isEmpty ? null : _showStepsBottomSheet,
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: const LatLng(10.78, 106.69),
          initialZoom: 12,
        ),
        children: [
          TileLayer(
            urlTemplate: Env.OSM_TILE_URL,
            userAgentPackageName: 'frontend_nhom2.app',
          ),
          PolylineLayer(
            polylines: [Polyline(points: _route, strokeWidth: 5.0)],
          ),
          MarkerLayer(
            markers: [
              for (int i = 0; i < _markers.length; i++)
                Marker(
                  point: _markers[i],
                  width: 40,
                  height: 40,
                  child: CircleAvatar(
                    child: Text(
                      '${i + 1}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: (_route.isEmpty)
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Tổng quãng đường: ${(_distanceM / 1000).toStringAsFixed(1)} km • '
                  'Thời gian: ${(_durationS / 60).toStringAsFixed(0)} phút',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
=======
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
>>>>>>> 3ae696c0b5147b44fc64b4b51a8e18fa5d6b8053
    );
  }
}
