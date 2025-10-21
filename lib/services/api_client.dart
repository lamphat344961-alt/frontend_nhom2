import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class ApiClient {
  // Tạo một thể hiện duy nhất (singleton) cho ApiClient
  static final ApiClient _inst = ApiClient._internal();
  factory ApiClient() => _inst;

  // Khai báo Dio instance sẽ được sử dụng trong toàn bộ ứng dụng
  late final Dio dio;

  // Constructor nội bộ, chỉ được gọi một lần
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
        // giúp việc bắt lỗi ở các service trở nên đơn giản và nhất quán.
      ),
    );

    // Thêm Interceptor để tự động đính kèm token vào mỗi request
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Lấy token từ bộ nhớ an toàn
          final token = await TokenManager.getToken();
          if (token != null && token.isNotEmpty) {
            // Thêm token vào header Authorization
            options.headers['Authorization'] = 'Bearer $token';
          }
          // Cho phép request được gửi đi tiếp
          return handler.next(options);
        },
      ),
    );

    // Nên đặt ở cuối để nó có thể log cả thông tin mà các interceptor trước đã thêm vào (như token)
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true, // Bật để xem header, kiểm tra token
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );
  }
}
