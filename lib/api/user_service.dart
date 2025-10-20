import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_nhom2/models/user_model.dart';
import 'package:http/http.dart' as http;
import '../models/register_request_model.dart';
import '../utils/token_manager.dart';

class UserService {
  final String? _baseUrl = dotenv.env['BASE_URL'];

  // --- Hàm cũ: Tạo tài khoản cho tài xế ---
  Future<void> createDriver(RegisterRequestModel driver) async {
    final token = await TokenManager.getToken();
    // Endpoint này dựa trên file UserController.cs của bạn
    final response = await http.post(
      Uri.parse('$_baseUrl/User/create-driver'),
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

  // --- HÀM MỚI: Lấy danh sách tài xế ---
  Future<List<UserModel>> getDrivers() async {
    final token = await TokenManager.getToken();
    // QUAN TRỌNG: Backend của bạn cần có API này để trả về danh sách người dùng có vai trò "Driver".
    // Tôi giả định endpoint là '$_baseUrl/User/drivers'. Nếu khác, hãy báo tôi sửa lại.
    final response = await http.get(
      Uri.parse('$_baseUrl/User/drivers'),
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
}

