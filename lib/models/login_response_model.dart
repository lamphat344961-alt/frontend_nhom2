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
    final token = (json['token'] ?? json['Token'] ?? '').toString();
    final fullName = (json['fullName'] ?? json['FullName'] ?? '').toString();
    final role = (json['role'] ?? json['Role'] ?? '').toString();
    return LoginResponseModel(token: token, fullName: fullName, role: role);
  }
}
