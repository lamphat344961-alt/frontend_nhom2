class RegisterRequestModel {
  final String username;
  final String password;
  final String fullName;
  final String? phoneNumber;
  final String? cccd;
  final String role;

  RegisterRequestModel({
    required this.username,
    required this.password,
    required this.fullName,
    this.phoneNumber,
    this.cccd,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'cccd': cccd,
      'role': role,
    };
  }
}