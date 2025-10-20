class XeReadModel {
  final String bsXe;
  final String? tenxe;
  final String? ttXe;
  final int? userId;
  final String? driverFullName;

  XeReadModel({
    required this.bsXe,
    this.tenxe,
    this.ttXe,
    this.userId,
    this.driverFullName,
  });

  factory XeReadModel.fromJson(Map<String, dynamic> json) {
    return XeReadModel(
      bsXe: json['bs_XE'] as String,
      tenxe: json['tenxe'] as String?,
      ttXe: json['tt_XE'] as String?,
      userId: json['userId'] as int?,
      driverFullName: json['driverFullName'] as String?,
    );
  }
}


class XeCreateModel {
  final String bsXe;
  final String? tenxe;
  final String? ttXe;

  XeCreateModel({
    required this.bsXe,
    this.tenxe,
    this.ttXe,
  });

  Map<String, dynamic> toJson() {
    return {
      'bs_XE': bsXe,
      'tenxe': tenxe,
      'tt_XE': ttXe,
    };
  }
}

class XeUpdateModel {
  final String? tenXe;
  final String? ttXe;

  XeUpdateModel({
    this.tenXe,
    this.ttXe,
  });

  Map<String, dynamic> toJson() {
    return {
      'tenXe': tenXe,
      'tt_XE': ttXe,
    };
  }
}