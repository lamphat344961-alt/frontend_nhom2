class XeReadModel {
  final String bsXe; // bắt buộc
  final String? tenxe; // TENXE
  final String? ttXe; // TT_XE
  final int? userId; // UserId
  final String? driverFullName; // DriverFullName

  XeReadModel({
    required this.bsXe,
    this.tenxe,
    this.ttXe,
    this.userId,
    this.driverFullName,
  });

  factory XeReadModel.fromJson(Map<String, dynamic> j) {
    final rawBs = j['BS_XE'] ?? j['bS_XE'] ?? j['bsXe'] ?? j['BsXe'];
    if (rawBs == null) {
      throw const FormatException('Thiếu khóa BS_XE trong phản hồi Xe');
    }
    return XeReadModel(
      bsXe: rawBs.toString(),
      tenxe: j['TENXE'] ?? j['tenXe'] ?? j['tenxe'],
      ttXe: j['TT_XE'] ?? j['tt_XE'] ?? j['ttXe'],
      userId: j['UserId'] is int
          ? j['UserId'] as int
          : (j['UserId'] as num?)?.toInt(),
      driverFullName: j['DriverFullName'] ?? j['driverFullName'],
    );
  }
}

class XeCreateModel {
  final String bsXe; // bắt buộc
  final String? tenXe;
  final String? ttXe;

  XeCreateModel({required this.bsXe, this.tenXe, this.ttXe});

  Map<String, dynamic> toJson() {
    return {'BS_XE': bsXe, 'TENXE': tenXe, 'TT_XE': ttXe};
  }
}

class XeUpdateModel {
  final String? tenXe;
  final String? ttXe;

  XeUpdateModel({this.tenXe, this.ttXe});

  Map<String, dynamic> toJson() {
    return {'TENXE': tenXe, 'TT_XE': ttXe};
  }
}
