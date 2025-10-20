class HangHoaModel {
  final String mahh;
  final String? tenhh;
  final int sl;
  final String? maloai;

  HangHoaModel({
    required this.mahh,
    this.tenhh,
    required this.sl,
    this.maloai,
  });

  factory HangHoaModel.fromJson(Map<String, dynamic> json) {
    return HangHoaModel(
      mahh: json['mahh'] ?? '',
      tenhh: json['tenhh'],
      sl: json['sl'] ?? 0,
      maloai: json['maloai'],
    );
  }
}