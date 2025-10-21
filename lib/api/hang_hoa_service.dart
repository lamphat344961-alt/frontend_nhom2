import 'package:dio/dio.dart';
import 'package:frontend_nhom2/models/hang_hoa_model.dart';
import 'package:frontend_nhom2/services/api_client.dart';
import 'package:flutter/foundation.dart'; // Dùng cho debugPrint

class HangHoaService {
  final Dio _dio = ApiClient().dio;
  final String _endpoint = '/HangHoa';

  // Lấy danh sách tất cả Hàng Hóa
  Future<List<HangHoaModel>> getAllHangHoas() async {
    try {
      final response = await _dio.get(_endpoint);

      // Giả định response.data là List<dynamic> hoặc { data: List<dynamic> }
      dynamic root = response.data;
      List<dynamic> arr = [];

      if (root is List) {
        arr = root;
      } else if (root is Map<String, dynamic> &&
          (root.containsKey('data') || root.containsKey(r'$values'))) {
        arr = root['data'] ?? root[r'$values'] ?? [];
      }

      if (arr.isEmpty) {
        debugPrint(
          'getAllHangHoas: Danh sách rỗng hoặc cấu trúc response không đúng.',
        );
        return const <HangHoaModel>[];
      }

      return arr
          .where((e) => e != null)
          .map(
            (e) => HangHoaModel.fromJson(
              (e is Map<String, dynamic>) ? e : Map<String, dynamic>.from(e),
            ),
          )
          .toList();
    } on DioException catch (e) {
      debugPrint('Error getting HangHoas: ${e.message}');
      // Ném lỗi để UI xử lý
      throw Exception('Không thể tải danh sách hàng hóa. Vui lòng thử lại.');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định.');
    }
  }

  // Thêm mới Hàng Hóa
  Future<HangHoaModel> createHangHoa(HangHoaModel item) async {
    try {
      final response = await _dio.post(
        _endpoint,
        data: {
          'mahh': item.mahh,
          'tenhh': item.tenhh,
          'sl': item.sl,
          'maloai': item.maloai,
        },
      );
      // Backend trả về 201 Created với body là item vừa tạo
      return HangHoaModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw Exception('Mã hàng hóa đã tồn tại.');
      }

      String errorMessage = 'Lỗi tạo hàng hóa: ${e.message}';
      if (e.response?.data is String && e.response?.statusCode == 400) {
        errorMessage = e
            .response!
            .data; // Bắt lỗi BadRequest trả chuỗi thuần (ví dụ: Mã loại hàng không tồn tại)
      } else if (e.response?.data is Map &&
          e.response?.data.containsKey('detail')) {
        errorMessage = 'Lỗi tạo hàng hóa: ${e.response!.data['detail']}';
      }
      throw Exception(errorMessage);
    }
  }

  // THÊM: Cập nhật Hàng Hóa (PUT: api/HangHoa/{id})
  Future<void> updateHangHoa(HangHoaModel item) async {
    try {
      // API backend dùng PUT với ID trên URL và body là DTO
      await _dio.put(
        '$_endpoint/${item.mahh}',
        data: {'tenhh': item.tenhh, 'sl': item.sl, 'maloai': item.maloai},
      );
    } on DioException catch (e) {
      // Xử lý lỗi BadRequest/Validation (400) hoặc lỗi server khác
      String errorMessage = 'Lỗi cập nhật hàng hóa: ${e.message}';
      if (e.response?.data is String && e.response?.statusCode == 400) {
        errorMessage = e.response!.data; // Bắt lỗi BadRequest trả chuỗi thuần
      } else if (e.response?.data is Map &&
          e.response?.data.containsKey('detail')) {
        errorMessage = 'Lỗi cập nhật hàng hóa: ${e.response!.data['detail']}';
      }
      throw Exception(errorMessage);
    }
  }

  // THÊM: Xóa Hàng Hóa (DELETE: api/HangHoa/{id})
  Future<void> deleteHangHoa(String mahh) async {
    try {
      await _dio.delete('$_endpoint/$mahh');
    } on DioException catch (e) {
      // Backend controller trả về 409 Conflict nếu có khóa ngoại
      if (e.response?.statusCode == 409) {
        throw Exception(
          'Không thể xóa hàng hóa này vì nó đang được sử dụng trong một đơn hàng.',
        );
      }

      String errorMessage = 'Lỗi xóa hàng hóa: ${e.message}';
      if (e.response?.data is Map && e.response?.data.containsKey('detail')) {
        errorMessage = 'Lỗi xóa hàng hóa: ${e.response!.data['detail']}';
      }
      throw Exception(errorMessage);
    }
  }
}
