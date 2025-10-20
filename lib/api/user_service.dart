// lib/api/user_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/register_request_model.dart';
import '../utils/token_manager.dart';

class UserService {
  final String? _baseUrl = dotenv.env['BASE_URL'];

  // Owner tạo tài khoản cho tài xế mới
  Future<void> createDriver(RegisterRequestModel driverData) async {
    // Lấy token của Owner đang đăng nhập
    final token = await TokenManager.getToken();
    if (token == null) {
      throw Exception('Không tìm thấy token xác thực. Vui lòng đăng nhập lại.');
    }

    final response = await http.post(
      // Endpoint dựa trên UserController.cs
      Uri.parse('$_baseUrl/User/create-driver'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(driverData.toJson()),
    );

    if (response.statusCode != 200) {
      // Cố gắng giải mã lỗi từ backend để hiển thị
      try {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? errorData['title'] ?? response.body;
        throw Exception('Thêm tài xế thất bại: $errorMessage');
      } catch(_) {
        throw Exception('Thêm tài xế thất bại: ${response.statusCode}');
      }
    }
  }
}

