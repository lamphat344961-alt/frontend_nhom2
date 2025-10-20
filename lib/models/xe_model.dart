class XeModel {
  final String bsXe;
  final String? tenXe;
  final String? ttXe;
  final int? userId;
  final String? driverFullName;

  XeModel({
    required this.bsXe,
    this.tenXe,
    this.ttXe,
    this.userId,
    this.driverFullName,
  });

  factory XeModel.fromJson(Map<String, dynamic> json) {
    return XeModel(
      bsXe: json['bs_XE'] ?? '',
      tenXe: json['tenxe'],
      ttXe: json['tt_XE'],
      userId: json['userId'],
      driverFullName: json['driverFullName'],
    );
  }
}