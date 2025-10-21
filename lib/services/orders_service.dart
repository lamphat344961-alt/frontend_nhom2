import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';
import 'package:frontend_nhom2/models/diem_giao_model.dart';
import 'package:frontend_nhom2/services/api_client.dart'; // Đảm bảo đã import

class OrdersService {
  // Sử dụng thể hiện Dio đã được cấu hình từ ApiClient (không tạo Dio mới)
  final Dio _dio = ApiClient().dio;

  OrdersService() {
    // Tích hợp LogInterceptor vào dio instance
    // Kiểm tra để tránh thêm nhiều lần nếu OrdersService được khởi tạo nhiều lần
    if (!_dio.interceptors.any((element) => element is LogInterceptor)) {
      _dio.interceptors.add(
        LogInterceptor(request: true, requestBody: false, responseBody: false),
      );
    }
  }

  // Lấy danh sách đơn hàng đã được giao cho tài xế (Driver)
  Future<List<DonHangItem>> getMyDeliveries() async {
    // Các đường dẫn API tiềm năng, thử lần lượt
    final paths = <String>[
      '/Driver/my-deliveries',
      '/Driver/MyDeliveries',
      '/DonHang/assigned',
      '/DonHang/mine',
      '/DonHang', // fallback
    ];

    for (final p in paths) {
      try {
        final res = await _dio.get(p);

        // --- BẮT ĐẦU XỬ LÝ TRẠNG THÁI HTTP (CODE FIX) ---
        if (res.statusCode == 200) {
          final data = res.data;
          if (data is List) {
            // Sử dụng fromDriverJson để đảm bảo dữ liệu tương thích với mô hình Driver
            return data
                .map(
                  (e) =>
                      DonHangItem.fromDriverJson(Map<String, dynamic>.from(e)),
                )
                .toList();
          }
        } else if (res.statusCode == 401) {
          // Lỗi xác thực: Token không hợp lệ/hết hạn
          throw Exception('AUTH_401');
        } else if (res.statusCode == 403) {
          // Lỗi ủy quyền: Tài khoản không có quyền truy cập endpoint này (sai role)
          throw Exception('AUTH_403');
        } else if (res.statusCode != 404) {
          // Các lỗi HTTP khác không phải 404
          throw Exception('HTTP ${res.statusCode} @ $p');
        }
        // --- KẾT THÚC XỬ LÝ TRẠNG THÁI HTTP ---
      } on DioException catch (e) {
        // Chỉ rethrow các lỗi nghiêm trọng (ví dụ: mất mạng, lỗi server 5xx)
        // Bỏ qua lỗi 404 nếu xảy ra do thử endpoint không tồn tại
        if (e.response?.statusCode != 404) rethrow;
      }
    }
    // Nếu duyệt qua hết tất cả các path mà không thành công (hoặc chỉ gặp 404)
    throw Exception('NO_DELIVERY_ENDPOINT_FOUND');
  }

  // Lấy CtDiemGiao theo đơn để bổ sung Lat/Lng
  Future<List<Map<String, dynamic>>> getCtDiemGiaoByDon(String maDon) async {
    final res = await _dio.get('/CtDiemGiao/by-don/$maDon');
    if (res.statusCode == 200) {
      final list = res.data;
      if (list is List) return list.cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
  }

  // Helper: trộn lat/lng vào danh sách đơn
  Future<List<DonHangItem>> enrichWithLatLng(List<DonHangItem> orders) async {
    final result = <DonHangItem>[];
    for (final o in orders) {
      if (o.lat != null && o.lng != null) {
        result.add(o);
        continue;
      }
      // Thử gọi CtDiemGiao/by-don
      final details = await getCtDiemGiaoByDon(o.maDon);
      // tìm item có DiemGiao
      for (final d in details) {
        final dgJson = d['DiemGiao'] ?? d['diemGiao'];
        if (dgJson != null) {
          final dg = DiemGiao.fromJson(Map<String, dynamic>.from(dgJson));
          if (dg.lat != null && dg.lng != null) {
            result.add(o.copyWith(lat: dg.lat, lng: dg.lng));
            break;
          }
        }
      }
      // nếu vẫn chưa có → giữ nguyên
      if (!result.any((x) => x.maDon == o.maDon)) result.add(o);
    }
    return result;
  }
}
