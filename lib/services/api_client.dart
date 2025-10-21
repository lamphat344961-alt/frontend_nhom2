import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class ApiClient {
  static final ApiClient _inst = ApiClient._internal();
  factory ApiClient() => _inst;

  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: '${Env.BASE_URL}/api',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // Để Dio trả về response ngay cả khi gặp lỗi 4xx/5xx, giúp tự xử lý.
        validateStatus: (_) => true,
      ),
    );

    // LogInterceptor để hiển thị chi tiết request/response/error trong console.
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    // Cấu hình Interceptor để tự động thêm Token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            // Cập nhật: Kiểm tra nếu token đã có prefix 'Bearer ' chưa
            options.headers['Authorization'] = token.startsWith('Bearer ')
                ? token
                : 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
