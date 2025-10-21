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
    try {
      final res = await _http.post('/login', data: payload.toJson());
      if (res.statusCode == 200) {
        final data = res.data as Map<String, dynamic>;

        final raw = (data['token'] ?? '').toString();
        final role = (data['role'] ?? '').toString();
        final fullName = (data['fullName'] ?? '').toString();

        // Loại bỏ tiền tố 'Bearer ' nếu có
        final token = raw.startsWith('Bearer ') ? raw.substring(7) : raw;

        if (token.isEmpty || role.isEmpty) {
          throw Exception('Token hoặc Role không được trả về từ server.');
        }

        await TokenManager.saveUserDetails(
          token: token,
          fullName: fullName,
          role: role,
        );
      } else {
        throw Exception('Đăng nhập thất bại: ${res.statusCode}');
      }
    } on DioException catch (e) {
      // Xử lý lỗi chi tiết hơn từ Dio
      final message = e.response?.data?['message'] ?? e.message;
      throw Exception('Lỗi mạng hoặc server: $message');
    } catch (e) {
      throw Exception('Đã xảy ra lỗi không xác định: $e');
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
