class DiemGiaoModel {
  final String idDD;
  final String? ten;
  final String? vitri;

  DiemGiaoModel({
    required this.idDD,
    this.ten,
    this.vitri,
  });

  factory DiemGiaoModel.fromJson(Map<String, dynamic> json) {
    return DiemGiaoModel(
      idDD: json['idDD'] ?? '',
      ten: json['ten'],
      vitri: json['vitri'],
    );
  }
}