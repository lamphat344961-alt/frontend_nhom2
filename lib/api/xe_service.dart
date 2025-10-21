import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/xe_model.dart';
import '../utils/token_manager.dart';

// ĐỊNH NGHĨA MODEL BODY CHO VIỆC GÁN TÀI XẾ
class AssignDriverRequestModel {
  final int userId;
  AssignDriverRequestModel({required this.userId});
  Map<String, dynamic> toJson() => {'userId': userId};
}

class XeService {
  final String? _baseUrl = dotenv.env['BASE_URL'];

  // HÀM 1: Lấy danh sách xe
  Future<List<XeReadModel>> getVehicles() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/Xe'), // Sửa: Xóa /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => XeReadModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  // HÀM 2: Tạo xe mới
  Future<void> createVehicle(XeCreateModel vehicle) async {
    final token = await TokenManager.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/Xe'), // Sửa: Xóa /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(vehicle.toJson()),
    );

    if (response.statusCode != 201) { // 201 Created
      throw Exception('Failed to create vehicle: ${response.body}');
    }
  }

  // --- HÀM 3 (MỚI): Cập nhật xe ---
  Future<void> updateVehicle(String bsxe, XeUpdateModel vehicle) async {
    final token = await TokenManager.getToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/Xe/$bsxe'), // Sửa: Xóa /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(vehicle.toJson()),
    );

    if (response.statusCode != 204) { // 204 No Content
      throw Exception('Failed to update vehicle: ${response.body}');
    }
  }

  // --- HÀM 4 (MỚI): Xóa xe ---
  Future<void> deleteVehicle(String bsxe) async {
    final token = await TokenManager.getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/Xe/$bsxe'), // Sửa: Xóa /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 204) { // 204 No Content
      throw Exception('Failed to delete vehicle: ${response.body}');
    }
  }

  // --- HÀM 5 (MỚI): Gán tài xế ---
  Future<void> assignDriver(String bsxe, int userId) async {
    final token = await TokenManager.getToken();
    final body = AssignDriverRequestModel(userId: userId);

    final response = await http.put(
      Uri.parse('$_baseUrl/Xe/$bsxe/assign-driver'), // Đã xóa /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(body.toJson()),
    );

    // --- BẮT ĐẦU SỬA LỖI ---
    if (response.statusCode != 200) {
      // Cố gắng decode lỗi JSON từ server
      try {
        final Map<String, dynamic> errorData = json.decode(response.body);
        // Backend ASP.NET Core thường trả lỗi 400 với key là 'title'
        final message = errorData['title'] ?? response.body;
        throw Exception(message);
      } catch (e) {
        // Nếu body không phải JSON, ném lỗi gốc
        throw Exception('Failed to assign driver: ${response.body}');
      }
    }
  }
}
    // --- KẾT THÚC SỬA LỖI ---