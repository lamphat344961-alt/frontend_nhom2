import 'package:dio/dio.dart';
import 'package:frontend_nhom2/models/diem_giao_model.dart';
import 'package:frontend_nhom2/models/don_hang_model.dart';
import 'package:frontend_nhom2/services/api_client.dart';

class OrdersService {
  // Sử dụng thể hiện Dio duy nhất đã được cấu hình từ ApiClient
  final Dio _dio = ApiClient().dio;

  get DiemGiao => null;

  // Lấy danh sách đơn hàng đã được giao cho tài xế (Driver)
  Future<List<DonHangItem>> getMyDeliveries() async {
    try {
      // Gọi đến endpoint duy nhất và chính xác của backend
      final res = await _dio.get('/Driver/my-deliveries');

      // Nếu request thành công (code 200), Dio sẽ không báo lỗi và chạy xuống đây
      final data = res.data;
      if (data is List) {
        // Ánh xạ dữ liệu JSON nhận được thành danh sách các đối tượng DonHangItem
        return data
            .map(
              (e) => DonHangItem.fromDriverJson(Map<String, dynamic>.from(e)),
            )
            .toList();
      }
      // Nếu data trả về không phải là một danh sách, trả về mảng rỗng để tránh lỗi
      return [];
    } on DioException catch (e) {
      // Bắt lỗi tập trung do Dio ném ra
      if (e.response != null) {
        // Trường hợp có phản hồi từ server nhưng là mã lỗi (4xx, 5xx)
        switch (e.response!.statusCode) {
          case 401:
            throw Exception('AUTH_401: Token không hợp lệ hoặc đã hết hạn.');
          case 403:
            throw Exception(
              'AUTH_403: Bạn không có quyền truy cập chức năng này.',
            );
          default:
            throw Exception('Lỗi từ Server: ${e.response!.statusCode}');
        }
      } else {
        // Trường hợp không có phản hồi từ server (ví dụ: mất mạng, sai địa chỉ IP)
        throw Exception('Lỗi kết nối mạng, vui lòng kiểm tra lại.');
      }
    } catch (e) {
      // Bắt các lỗi không lường trước khác
      throw Exception('Đã xảy ra lỗi không xác định: $e');
    }
  }

  // Lấy chi tiết điểm giao theo mã đơn hàng
  Future<List<Map<String, dynamic>>> getCtDiemGiaoByDon(String maDon) async {
    try {
      // Endpoint này cần tồn tại bên backend
      final res = await _dio.get('/CtDiemGiao/by-don/$maDon');
      final list = res.data;
      if (list is List) {
        return list.cast<Map<String, dynamic>>();
      }
      return [];
    } catch (e) {
      // Bỏ qua lỗi nếu không tìm thấy chi tiết, trả về mảng rỗng
      print('Không tìm thấy chi tiết điểm giao cho đơn $maDon: $e');
      return [];
    }
  }

  // Helper: Bổ sung thông tin lat/lng vào danh sách đơn hàng
  Future<List<DonHangItem>> enrichWithLatLng(List<DonHangItem> orders) async {
    final result = <DonHangItem>[];
    for (final o in orders) {
      // Nếu đã có tọa độ thì bỏ qua
      if (o.lat != null && o.lng != null) {
        result.add(o);
        continue;
      }

      // Nếu chưa có, gọi API để lấy chi tiết điểm giao
      final details = await getCtDiemGiaoByDon(o.maDon);
      bool foundLatLng = false;
      for (final d in details) {
        // Kiểm tra cả 'diemGiao' (chữ thường) và 'DiemGiao' (chữ hoa)
        final dgJson = d['diemGiao'] ?? d['DiemGiao'];
        if (dgJson != null) {
          final dg = DiemGiao.fromJson(Map<String, dynamic>.from(dgJson));
          if (dg.lat != null && dg.lng != null) {
            result.add(o.copyWith(lat: dg.lat, lng: dg.lng));
            foundLatLng = true;
            break; // Dừng lại khi tìm thấy tọa độ đầu tiên
          }
        }
      }

      // Nếu sau khi gọi API vẫn không tìm thấy tọa độ, giữ nguyên đơn hàng cũ
      if (!foundLatLng) {
        result.add(o);
      }
    }
    return result;
  }
}
