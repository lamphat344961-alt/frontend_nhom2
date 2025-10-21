import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenManager {
  // Khóa lưu trữ bảo mật
  static const _kTok = 'auth_token';
  static const _kRole = 'auth_role';
  static const _kFullName = 'user_fullName'; // Giữ lại khóa này để tương thích

  // Khởi tạo FlutterSecureStorage
  static final _s = const FlutterSecureStorage();

  // Lưu token và vai trò
  static Future<void> saveUserDetails({
    required String token,
    String? fullName,
    required String role,
  }) async {
    await _s.write(key: _kTok, value: token);
    await _s.write(key: _kRole, value: role);
    // Lưu fullName (nếu có), nếu không có thì không lưu.
    if (fullName != null) {
      await _s.write(key: _kFullName, value: fullName);
    }
  }

  // Lấy token
  static Future<String?> getToken() => _s.read(key: _kTok);

  // Lấy vai trò
  static Future<String?> getRole() => _s.read(key: _kRole);

  // Lấy tên đầy đủ (giữ lại để tương thích với các đoạn code gọi nó)
  static Future<String?> getFullName() => _s.read(key: _kFullName);

  // Xóa toàn bộ thông tin
  static Future<void> clearAll() => _s.deleteAll();
}
