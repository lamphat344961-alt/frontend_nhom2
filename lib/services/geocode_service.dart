// lib/services/geocode_service.dart
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';

class GeocodeService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.NOMINATIM_BASE_URL,
      headers: {'User-Agent': Env.NOMINATIM_UA},
      connectTimeout: const Duration(seconds: 12),
    ),
  );

  // throttle: tối thiểu 1 request / 1s
  DateTime _last = DateTime.fromMillisecondsSinceEpoch(0);

  Future<List<double>?> geocodeOnce(String address) async {
    final now = DateTime.now();
    final diff = now.difference(_last);
    if (diff.inMilliseconds < 1000) {
      await Future.delayed(Duration(milliseconds: 1000 - diff.inMilliseconds));
    }
    _last = DateTime.now();

    final res = await _dio.get(
      '/search',
      queryParameters: {'q': address, 'format': 'json', 'limit': 1},
    );

    if (res.statusCode == 200 &&
        res.data is List &&
        (res.data as List).isNotEmpty) {
      final j = res.data[0];
      final lat = double.tryParse(j['lat']?.toString() ?? '');
      final lon = double.tryParse(j['lon']?.toString() ?? '');
      if (lat != null && lon != null) return [lat, lon];
    }
    return null;
  }

  // TODO: khoá Nominatim công khai khi deploy; cân nhắc self-host.
}
