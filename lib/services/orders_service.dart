import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';
import 'package:frontend_nhom2/services/api_client.dart';
import 'package:flutter/foundation.dart';

class OrdersService {
  final Dio _dio = ApiClient().dio;

<<<<<<< HEAD
  get DiemGiao => null;

  // Lấy danh sách đơn hàng đã được giao cho tài xế (Driver)
=======
>>>>>>> 3ae696c0b5147b44fc64b4b51a8e18fa5d6b8053
  Future<List<DonHangItem>> getMyDeliveries() async {
    final res = await _dio.get('/Driver/my-deliveries');
    dynamic root = res.data;

    // Nếu body là chuỗi thuần (ví dụ: "Bạn chưa được gán xe nào.") -> coi như không có đơn
    if (root is String) {
      debugPrint('my-deliveries text: $root');
      // Không ném lỗi. Trả danh sách rỗng để UI hiển thị "Chưa có đơn giao".
      return const <DonHangItem>[];
    }

    if (root is String &&
        (root.trim().startsWith('[') || root.trim().startsWith('{'))) {
      root = jsonDecode(root);
    }

    dynamic arr;
    if (root is List) {
      arr = root;
    } else if (root is Map<String, dynamic>) {
      arr =
          root['data'] ??
          root['items'] ??
          root['records'] ??
          root['result'] ??
          root['list'] ??
          root[r'$values'];
    }

    if (arr is! List) return const <DonHangItem>[];

    return arr
        .map(
          (e) => DonHangItem.fromDriverJson(
            (e is Map<String, dynamic>) ? e : Map<String, dynamic>.from(e),
          ),
        )
        .toList();
  }

  Future<List<DonHangItem>> hydrateLatLng(List<DonHangItem> items) async =>
      items;
}
