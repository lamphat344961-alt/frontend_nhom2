// lib/providers/auth_provider.dart
import 'package:flutter/foundation.dart';
import 'package:frontend_nhom2/services/auth_service.dart';
import 'package:frontend_nhom2/utils/token_manager.dart';

class AuthProvider with ChangeNotifier {
  final AuthServiceV2 _auth = AuthServiceV2();
  bool _loading = false;

  bool get isLoading => _loading;

  Future<String?> tryAutoRole() async => await TokenManager.getRole();

  Future<void> login(String u, String p) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.login(AuthPayload(u, p));
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String u,
    required String p,
    required String name,
    String? phone,
  }) async {
    _loading = true;
    notifyListeners();
    try {
      await _auth.register(
        RegisterPayload(
          username: u,
          password: p,
          fullName: name,
          phoneNumber: phone,
        ),
      );
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.logout();
    notifyListeners();
  }
}
