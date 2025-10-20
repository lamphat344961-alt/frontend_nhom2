class UserModel {
  final int userId;
  final String username;
  final String fullName;
  final String? phoneNumber;
  final String? cccd;

  UserModel({
    required this.userId,
    required this.username,
    required this.fullName,
    this.phoneNumber,
    this.cccd,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      username: json['username'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      cccd: json['cccd'],
    );
  }
}