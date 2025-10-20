class CtDonHangModel {
  final String madon;
  final String mahh;
  final double dongia;
  final int sl;

  CtDonHangModel({
    required this.madon,
    required this.mahh,
    required this.dongia,
    required this.sl,
  });

  factory CtDonHangModel.fromJson(Map<String, dynamic> json) {
    return CtDonHangModel(
      madon: json['madon'] ?? '',
      mahh: json['mahh'] ?? '',
      dongia: (json['dongia'] as num?)?.toDouble() ?? 0.0,
      sl: json['sl'] ?? 0,
    );
  }
}