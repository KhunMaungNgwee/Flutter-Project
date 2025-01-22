// lib/features/auth/models/user_model.dart

//This model is only for sample
class UserResponse {
  final int id;
  final String fullName;
  final String profilePic;
  final String companyId;

  UserResponse(
      {required this.id,
      required this.fullName,
      required this.profilePic,
      required this.companyId});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      profilePic: json['profilePic'] as String,
      companyId: json['companyId'] as String,
    );
  }
}
