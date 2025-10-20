class DonHangModel {
  final String madon;
  final String? maloai;
  final DateTime ngaylap;
  final double tongtien; // Sử dụng double trong Dart cho decimal

  DonHangModel({
    required this.madon,
    this.maloai,
    required this.ngaylap,
    required this.tongtien,
  });

  factory DonHangModel.fromJson(Map<String, dynamic> json) {
    return DonHangModel(
      madon: json['madon'] ?? '',
      maloai: json['maloai'],
      // Chuyển đổi chuỗi String ISO 8601 từ JSON thành đối tượng DateTime
      ngaylap: DateTime.parse(json['ngaylap']),
      // json['tongtien'] có thể là int hoặc double, nên dùng num.toDouble()
      tongtien: (json['tongtien'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
