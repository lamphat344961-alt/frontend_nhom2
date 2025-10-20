class AssignDriverRequestModel {
  final int userId;

  AssignDriverRequestModel({required this.userId});

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}