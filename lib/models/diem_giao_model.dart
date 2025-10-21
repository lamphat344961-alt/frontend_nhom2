// lib/models/diem_giao.dart
class DiemGiao {
  final String idDD;
  final String? ten;
  final String? viTri;
  final double? lat;
  final double? lng;

  DiemGiao({required this.idDD, this.ten, this.viTri, this.lat, this.lng});

  factory DiemGiao.fromJson(Map<String, dynamic> j) => DiemGiao(
    idDD: j['IdDD']?.toString() ?? j['idDD']?.toString() ?? '',
    ten: j['TEN']?.toString() ?? j['ten']?.toString(),
    viTri: j['VITRI']?.toString() ?? j['vitri']?.toString(),
    lat: (j['Lat'] ?? j['lat']) == null
        ? null
        : (j['Lat'] ?? j['lat']).toDouble(),
    lng: (j['Lng'] ?? j['lng']) == null
        ? null
        : (j['Lng'] ?? j['lng']).toDouble(),
  );
}
