import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart'; // Thêm Provider
// THÊM CÁC IMPORTS CHO KẾT NỐI BACKEND
import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart'; // Cần import Env để lấy BASE_URL

import 'http_overrides.dart'; // Giữ lại cho cấu hình dev
import 'screens/auth/login_screen.dart';
// Giả định các Providers và Theme nằm trong các đường dẫn sau:
import 'package:frontend_nhom2/providers/auth_provider.dart';
import 'package:frontend_nhom2/providers/orders_provider.dart';
import 'package:frontend_nhom2/theme/app_theme.dart';

// ----------------------------------------------------------------------
// THÊM HÀM KIỂM TRA KẾT NỐI BACKEND
// ----------------------------------------------------------------------
Future<void> testBackendConnection() async {
  final dio = Dio();
  final url =
      '${Env.BASE_URL}/swagger/index.html'; // Kiểm tra một endpoint công khai
  try {
    final res = await dio.get(url);
    // Sử dụng print cho mục đích debug/test
    print('✅ Connected to $url — Status: ${res.statusCode}');
  } on DioException catch (e) {
    if (e.response != null) {
      print('⚠️ Server responded with ${e.response?.statusCode} from $url');
    } else {
      print('❌ Cannot reach backend: ${e.message}');
    }
  }
}
// ----------------------------------------------------------------------

Future<void> main() async {
  // Đảm bảo các thành phần của Flutter đã sẵn sàng trước khi chạy code.
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình để bỏ qua kiểm tra chứng chỉ SSL (cho môi trường dev).
  HttpOverrides.global = MyHttpOverrides();

  // Tải các biến môi trường từ file .env.
  await dotenv.load(fileName: ".env");

  // CHẠY HÀM KIỂM TRA KẾT NỐI
  await testBackendConnection();

  // Thay thế runApp bằng MultiProvider để cung cấp Auth và Orders Providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // Constructor đơn giản
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sử dụng appTheme() và đặt home là LoginScreen
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      // Màn hình bắt đầu là LoginScreen.
      home: const LoginScreen(),
    );
  }
}
