// lib/features/auth/models/user_model.dart

//This model is only for sample
class UserModel {
  final String abbreviation;
  final String fullName;
  final String password;


  UserModel({required this.abbreviation, required this.fullName, required this.password});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      abbreviation: json['abbreviation'] as String,
      fullName: json['fullName'] as String,
      password: json['password'] as String,
    );
  }
}
