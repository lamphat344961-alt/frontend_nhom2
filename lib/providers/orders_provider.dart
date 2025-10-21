// lib/providers/orders_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';
import 'package:frontend_nhom2/services/geocode_service.dart';
import 'package:frontend_nhom2/services/orders_service.dart';

class OrdersProvider with ChangeNotifier {
  final OrdersService _svc = OrdersService();
  final GeocodeService _geo = GeocodeService();

  bool _loading = false;
  List<DonHangItem> _items = [];
  DonHangItem? _focused; // để focus marker theo "Xem bản đồ"

  bool get isLoading => _loading;
  List<DonHangItem> get items => _items;
  DonHangItem? get focused => _focused;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    try {
      var list = await _svc.getMyDeliveries();
      list = await _svc.enrichWithLatLng(list);

      // nếu vẫn thiếu lat/lng mà có địa chỉ → geocode tạm
      final enriched = <DonHangItem>[];
      for (final o in list) {
        if (o.lat != null && o.lng != null) {
          enriched.add(o);
        } else if ((o.diaChi ?? '').isNotEmpty) {
          final p = await _geo.geocodeOnce(o.diaChi!);
          if (p != null) {
            enriched.add(o.copyWith(lat: p[0], lng: p[1]));
          } else {
            enriched.add(o); // TODO: cảnh báo thiếu toạ độ
          }
        } else {
          enriched.add(o);
        }
      }
      _items = enriched;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void focusOrder(String maDon) {
    _focused = _items.firstWhere(
      (e) => e.maDon == maDon,
      orElse: () =>
          _focused ?? (_items.isNotEmpty ? _items.first : null) as DonHangItem,
    );
    notifyListeners();
  }

  void clearFocus() {
    _focused = null;
    notifyListeners();
  }
}
