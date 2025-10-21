// lib/services/route_service.dart (bổ sung)
import 'dart:convert';
import 'dart:core';
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

  // ========== 1) Tối ưu thứ tự điểm dừng (OSRM Trip) ==========
  // points: [ [lat, lng], ... ]
  // return: {
  //   "polyline": List<List<double>> (lat,lng) đã giải mã,
  //   "order": List<int> thứ tự index ban đầu sau tối ưu,
  //   "distance": double (m),
  //   "duration": double (s),
  //   "legs": List<steps> (để hiển thị chỉ dẫn turn-by-turn)
  // }
  Future<Map<String, dynamic>> optimizeTrip(List<List<double>> points) async {
    if (points.length < 2) {
      return {
        "polyline": <List<double>>[],
        "order": <int>[],
        "distance": 0.0,
        "duration": 0.0,
        "legs": [],
      };
    }

    // OSRM nhận lng,lat
    final coords = points
        .map((p) => '${p[1].toStringAsFixed(6)},${p[0].toStringAsFixed(6)}')
        .join(';');

    // source=first, destination=last => cố định điểm đầu/cuối; nếu không muốn cố định thì bỏ 2 params này
    final url =
        '/trip/v1/driving/$coords'
        '?roundtrip=false&source=first&destination=last'
        '&overview=full&geometries=polyline6&steps=true';

    final res = await _dio.get(url);
    if (res.statusCode != 200) {
      throw Exception(
        'OSRM trip failed: ${res.statusCode} ${res.statusMessage}',
      );
    }

    final trips = (res.data['trips'] as List?) ?? [];
    if (trips.isEmpty) {
      return {
        "polyline": <List<double>>[],
        "order": <int>[],
        "distance": 0.0,
        "duration": 0.0,
        "legs": [],
      };
    }

    final best = trips.first; // OSRM đã chọn phương án tối ưu
    final poly = best['geometry'] as String;
    final distance = (best['distance'] as num).toDouble();
    final duration = (best['duration'] as num).toDouble();

    // waypoint_index -> vị trí trong chuỗi tối ưu; original -> index ban đầu
    // Ta muốn mảng "order" thể hiện mapping index ban đầu -> vị trí sau tối ưu
    final waypoints = (res.data['waypoints'] as List?) ?? [];
    final indexed = List.generate(
      waypoints.length,
      (i) => {'inputIndex': i, 'wp': waypoints[i]},
    );
    indexed.sort(
      (a, b) => ((a['wp']['waypoint_index'] ?? 0) as int).compareTo(
        (b['wp']['waypoint_index'] ?? 0) as int,
      ),
    );
    final order = indexed.map<int>((e) => e['inputIndex'] as int).toList();

    // legs + steps: để show chỉ dẫn rẽ
    final legs = (best['legs'] as List?) ?? [];

    return {
      "polyline": decodePolyline6(poly),
      "order": order,
      "distance": distance,
      "duration": duration,
      "legs": legs,
    };
  }

  // ========== 2) Route theo thứ tự hiện có (giữ lại) ==========
  Future<List<List<Object>>> buildRoute(List<List<double>> points) async {
    if (points.length < 2) return <List<List<double>>>[];

    final coords = points
        .map(
          (p) => '${p[1].toStringAsFixed(6)},${p[0].toStringAsFixed(6)}',
        ) // lng,lat
        .join(';');

    final url =
        '/route/v1/driving/$coords?overview=full&geometries=polyline6&steps=true';
    final res = await _dio.get(url);
    if (res.statusCode == 200) {
      final routes = (res.data['routes'] as List);
      if (routes.isEmpty) return <List<List<double>>>[];
      final poly = routes.first['geometry'] as String;
      return decodePolyline6(poly);
    }
    throw Exception(
      'OSRM route failed: ${res.statusCode} ${res.statusMessage}',
    );
  }

  // ========== 3) Giải mã polyline 6 ==========
  List<List<double>> decodePolyline6(String encoded) {
    int index = 0, len = encoded.length, lat = 0, lng = 0;
    final coordinates = <List<double>>[];
    while (index < len) {
      int b, shift = 0, result = 0;
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
