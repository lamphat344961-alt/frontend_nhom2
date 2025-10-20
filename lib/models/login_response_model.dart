class LoginResponseModel {
  final String token;
  final String fullName;
  final String role;

  LoginResponseModel({
    required this.token,
    required this.fullName,
    required this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
    );
  }
}