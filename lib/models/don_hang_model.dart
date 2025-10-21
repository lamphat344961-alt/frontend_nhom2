class DonHangItem {
  final String maDon;
  final String? idDiemGiao;
  final String? tenDiemGiao;
  final String? diaChi;
  final String? trangThai;
  final String? bienSoXe;
  final String? ngayGiaoDuKien;

  // toạ độ nếu có (từ CtDiemGiao/by-don)
  final double? lat;
  final double? lng;

  DonHangItem({
    required this.maDon,
    this.idDiemGiao,
    this.tenDiemGiao,
    this.diaChi,
    this.trangThai,
    this.bienSoXe,
    this.ngayGiaoDuKien,
    this.lat,
    this.lng,
  });

  DonHangItem copyWith({double? lat, double? lng}) => DonHangItem(
    maDon: maDon,
    idDiemGiao: idDiemGiao,
    tenDiemGiao: tenDiemGiao,
    diaChi: diaChi,
    trangThai: trangThai,
    bienSoXe: bienSoXe,
    ngayGiaoDuKien: ngayGiaoDuKien,
    lat: lat ?? this.lat,
    lng: lng ?? this.lng,
  );

  factory DonHangItem.fromDriverJson(Map<String, dynamic> j) => DonHangItem(
    maDon: j['MaDonHang']?.toString() ?? j['maDon']?.toString() ?? '',
    idDiemGiao: j['IdDiemGiao']?.toString(),
    tenDiemGiao: j['TenDiemGiao']?.toString(),
    diaChi: j['DiaChiGiao']?.toString(),
    trangThai: j['TrangThai']?.toString(),
    bienSoXe: j['BienSoXe']?.toString(),
    ngayGiaoDuKien: j['NgayGiaoDuKien']?.toString(),
  );
}
