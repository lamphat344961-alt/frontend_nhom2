import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/xe_model.dart';
import '../utils/token_manager.dart';

class XeService {
  final String? _baseUrl = dotenv.env['BASE_URL'];

  Future<List<XeReadModel>> getVehicles() async {
    final token = await TokenManager.getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/Xe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => XeReadModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<void> createVehicle(XeCreateModel vehicle) async {
    final token = await TokenManager.getToken();
    final response = await http.post(
      Uri.parse('$_baseUrl/Xe'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(vehicle.toJson()),
    );

    if (response.statusCode != 201) { // 201 Created
      throw Exception('Failed to create vehicle: ${response.body}');
    }
  }
}