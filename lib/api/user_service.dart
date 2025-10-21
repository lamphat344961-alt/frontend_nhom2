import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_nhom2/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/register_request_model.dart';
import '../utils/token_manager.dart';

class UserService {
  final String? _baseUrl = dotenv.env['BASE_URL'];

  // HÀM MỚI: Lấy danh sách tài xế
  // Gọi: GET /api/User/drivers
  Future<List<UserModel>> getDrivers() async {
    final token = await TokenManager.getToken();

    // Endpoint chính xác từ UserController.cs
    final response = await http.get(
      Uri.parse('$_baseUrl/User/drivers'), // Sửa: Thêm /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => UserModel.fromJson(json)).toList();
    } else {
      throw Exception('Không thể tải danh sách tài xế');
    }
  }

  // Gọi: POST /api/User/create-driver
  Future<void> createDriver(RegisterRequestModel driver) async {
    final token = await TokenManager.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/User/create-driver'), // Sửa: Thêm /api
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(driver.toJson()),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Tạo tài khoản thất bại: ${response.body}');
    }
  }
}
