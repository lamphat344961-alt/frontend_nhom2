import 'package:flutter/foundation.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';
import 'package:frontend_nhom2/services/orders_service.dart';

enum OrdersState { idle, loading, loaded, error }

class OrdersProvider extends ChangeNotifier {
  final _svc = OrdersService();

  OrdersState state = OrdersState.idle;
  String? error;
  List<DonHangItem> items = [];
  DonHangItem? focused;

  Future<void> load() async {
    state = OrdersState.loading;
    error = null;
    notifyListeners();
    try {
      final raw = await _svc.getMyDeliveries();
      items = await _svc.hydrateLatLng(raw);
      state = OrdersState.loaded;
    } catch (e) {
      error = e.toString();
      state = OrdersState.error;
    }
    notifyListeners();
  }

  Future<void> refresh() => load();

  void focusOrder(String? maDon) {
    focused = items.firstWhere(
      (e) => e.maDon == maDon,
      orElse: () => items.isNotEmpty ? items.first : null as DonHangItem,
    );
    notifyListeners();
  }
}
