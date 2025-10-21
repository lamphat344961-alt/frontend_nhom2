// lib/constants/env.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get BASE_URL {
    final raw = dotenv.env['BASE_URL']?.trim() ?? 'http://10.0.2.2:5000';
    final cleaned = raw.replaceAll(RegExp(r'/+$'), '');
    // gỡ đuôi /api nếu người dùng lỡ điền
    return cleaned.replaceAll(RegExp(r'/api/?$'), '');
  }

  static String get OSM_TILE_URL =>
      dotenv.env['OSM_TILE_URL']?.trim() ??
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  static String get OSRM_BASE_URL =>
      dotenv.env['OSRM_BASE_URL']?.trim().replaceAll(RegExp(r'/+$'), '') ??
      'https://router.project-osrm.org';
  static String get NOMINATIM_BASE_URL =>
      dotenv.env['NOMINATIM_BASE_URL']?.trim().replaceAll(RegExp(r'/+$'), '') ??
      'https://nominatim.openstreetmap.org';

  // User-Agent riêng cho Nominatim
  static String get NOMINATIM_UA =>
      dotenv.env['NOMINATIM_UA']?.trim() ??
      'frontend_nhom2/1.0 (+contact: youremail@example.com)';
}
