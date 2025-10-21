// lib/services/route_service.dart
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:frontend_nhom2/constants/env.dart';

class RouteService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Env.OSRM_BASE_URL,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
    ),
  );

  // points: [ [lat, lng], ... ]
  Future<List<List<double>>> buildRoute(List<List<double>> points) async {
    // Nếu backend có polyline: TODO ánh xạ gọi /api/Route/... để dùng trực tiếp.
    if (points.length < 2) return <List<double>>[];

    // OSRM demo
    final coords = points
        .map(
          (p) => '${p[1].toStringAsFixed(6)},${p[0].toStringAsFixed(6)}',
        ) // lng,lat
        .join(';');

    final url = '/route/v1/driving/$coords?overview=full&geometries=polyline6';
    final res = await _dio.get(url);
    if (res.statusCode == 200) {
      final routes = (res.data['routes'] as List);
      if (routes.isEmpty) return <List<double>>[];
      final poly = routes.first['geometry'] as String;
      return decodePolyline6(poly);
    }
    throw Exception('OSRM route failed: ${res.statusCode}');
  }

  // Decode Google polyline6 → List<[lat,lng]>
  List<List<double>> decodePolyline6(String encoded) {
    final List<List<double>> coordinates = [];
    int index = 0, lat = 0, lng = 0;

    while (index < encoded.length) {
      int result = 0, shift = 0, b;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      result = 0;
      shift = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      coordinates.add([lat / 1e6, lng / 1e6]);
    }
    return coordinates;
  }
}
