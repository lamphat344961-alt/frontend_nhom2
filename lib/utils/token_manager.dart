import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String _tokenKey = 'jwt_token';
  static const String _fullNameKey = 'user_fullName';
  static const String _roleKey = 'user_role';

  // Lưu đầy đủ thông tin người dùng
  static Future<void> saveUserDetails({
    required String token,
    required String fullName,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_fullNameKey, fullName);
    await prefs.setString(_roleKey, role);
  }

  // Lấy token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Lấy tên đầy đủ
  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fullNameKey);
  }

  // Lấy vai trò
  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_roleKey);
  }

  // Xóa toàn bộ thông tin khi đăng xuất
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_fullNameKey);
    await prefs.remove(_roleKey);
  }
}

