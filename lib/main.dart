import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'http_overrides.dart';
import 'screens/auth/login_screen.dart';
import 'screens/owner/owner_dashboard_screen.dart';
import 'utils/token_manager.dart';

Future<void> main() async {
  // Đảm bảo các thành phần của Flutter đã sẵn sàng trước khi chạy code.
  WidgetsFlutterBinding.ensureInitialized();

  // Cấu hình để bỏ qua kiểm tra chứng chỉ SSL (cho môi trường dev).
  HttpOverrides.global = MyHttpOverrides();

  // Tải các biến môi trường từ file .env.
  await dotenv.load(fileName: ".env");

  // Kiểm tra xem có token đăng nhập được lưu từ lần trước không.
  final String? token = await TokenManager.getToken();

  // Chạy ứng dụng và truyền vào trạng thái đăng nhập.
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  // Biến để lưu trạng thái đăng nhập.
  final bool isLoggedIn;

  // Constructor để nhận trạng thái đăng nhập từ hàm main.
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey[50],
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4F46E5)),
        useMaterial3: true,
      ),
      // Quyết định màn hình bắt đầu dựa trên trạng thái đăng nhập.
      // Nếu isLoggedIn là true -> vào OwnerDashboardScreen.
      // Nếu isLoggedIn là false -> vào LoginScreen.
      home: isLoggedIn ? const OwnerDashboardScreen() : const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}