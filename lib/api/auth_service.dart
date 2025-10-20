import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class AuthService {
  // Lấy BASE_URL từ file .env
  final String? baseUrl = dotenv.env['BASE_URL'];

  // Hàm đăng nhập
  Future<LoginResponseModel> login(LoginRequestModel loginRequest) async {
    // 1. Kiểm tra xem BASE_URL có tồn tại không
    if (baseUrl == null) {
      throw Exception("Lỗi: Không tìm thấy BASE_URL trong file .env");
    }

    // 2. Tạo URL đầy đủ cho API login
    // Dựa trên AuthController.cs, endpoint là /api/Auth/login
    final url = Uri.parse('$baseUrl/Auth/login');

    // 3. Gửi request POST lên server
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginRequest.toJson()),
    );

    // 4. Xử lý kết quả trả về
    if (response.statusCode == 200) {
      // Nếu thành công (status code 200), chuyển JSON thành object Dart
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    } else {
      // Nếu thất bại, ném ra lỗi với thông báo từ server
      throw Exception('Đăng nhập thất bại: ${response.body}');
    }
  }
}