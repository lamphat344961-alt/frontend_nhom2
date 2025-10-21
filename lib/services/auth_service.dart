import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class AuthPayload {
  final String username;
  final String password;
  AuthPayload(this.username, this.password);

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class RegisterPayload {
  final String username;
  final String password;
  final String fullName;
  final String? phoneNumber;
  // Role thực tế của backend: "Driver" cho người dùng app User
  RegisterPayload({
    required this.username,
    required this.password,
    required this.fullName,
    this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'role': 'Driver',
  };
}

class AuthServiceV2 {
  final Dio _http = Dio(
    BaseOptions(
      baseUrl: '${Env.BASE_URL}/api/Auth',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      connectTimeout: const Duration(seconds: 15),
    ),
  );

  Future<void> login(AuthPayload payload) async {
    final res = await _http.post('/login', data: payload.toJson());
    if (res.statusCode == 200) {
      final data = res.data as Map<String, dynamic>;

      // Lấy raw token và role từ response, hỗ trợ nhiều kiểu chữ (cả CamelCase và lowercase)
      final raw = (data['Token'] ?? data['token'] ?? '').toString();
      final role = (data['Role'] ?? data['role'] ?? '').toString();

      // CHỈNH SỬA: Loại bỏ tiền tố 'Bearer ' nếu tồn tại trước khi lưu
      final token = raw.startsWith('Bearer ') ? raw.substring(7) : raw;

      final fullName = data['FullName'] ?? data['fullName'] ?? '';

      await TokenManager.saveUserDetails(
        token: token,
        fullName: fullName,
        role: role,
      );
    } else {
      throw Exception('Đăng nhập thất bại: ${res.statusCode}');
    }
  }

  Future<void> register(RegisterPayload payload) async {
    final res = await _http.post('/register', data: payload.toJson());
    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Đăng ký thất bại: ${res.statusCode} ${res.data}');
    }
  }

  Future<void> logout() async {
    await TokenManager.clearAll();
  }
}
