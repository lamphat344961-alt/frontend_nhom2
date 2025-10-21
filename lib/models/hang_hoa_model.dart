class HangHoaModel {
  final String mahh;
  final String? tenhh;
  final int sl;
  final String? maloai;

  HangHoaModel({required this.mahh, this.tenhh, required this.sl, this.maloai});

  factory HangHoaModel.fromJson(Map<String, dynamic> json) {
    return HangHoaModel(
      mahh: json['mahh'] ?? '',
      tenhh: json['tenhh'],
      sl: json['sl'] ?? 0,
      maloai: json['maloai'],
    );
  }

  // THÊM HÀM TOJSON CHO VIỆC GỬI DỮ LIỆU LÊN SERVER (POST/PUT)
  Map<String, dynamic> toJson() {
    return {'mahh': mahh, 'tenhh': tenhh, 'sl': sl, 'maloai': maloai};
  }

  // HÀM SAO CHÉP ĐỂ TẠO BẢN SAO CHO VIỆC CHỈNH SỬA
  HangHoaModel copyWith({
    String? mahh,
    String? tenhh,
    int? sl,
    String? maloai,
  }) {
    return HangHoaModel(
      mahh: mahh ?? this.mahh,
      tenhh: tenhh ?? this.tenhh,
      sl: sl ?? this.sl,
      maloai: maloai ?? this.maloai,
    );
  }
}
