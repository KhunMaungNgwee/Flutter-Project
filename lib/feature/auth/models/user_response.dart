class ProfilePic {
  final String? base64;
  final String? fileName;
  final String? url; // New field for handling direct image URLs

  ProfilePic({this.base64, this.fileName, this.url});

  factory ProfilePic.fromJson(dynamic json) {
    if (json is String) {
      // Case: profilePic is a URL string
      return ProfilePic(url: json);
    } else if (json is Map<String, dynamic>) {
      // Case: profilePic is a map with base64 and fileName
      return ProfilePic(
        base64: json['base64'] ?? '',
        fileName: json['fileName'] ?? '',
      );
    }
    // Default case
    return ProfilePic();
  }

  Map<String, dynamic> toJson() {
    return {
      'base64': base64,
      'fileName': fileName,
      'url': url,
    };
  }
}

class UserResponse {
  int id;
  String fullName;
  ProfilePic profilePic;
  String companyId;
  String firstName;
  String lastName;
  String prefix;
  String email;
  String gender;

  UserResponse({
    required this.id,
    required this.fullName,
    required this.profilePic,
    required this.companyId,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.prefix,
  });

  factory UserResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          'Expected a Map<String, dynamic>, but got: ${json.runtimeType}');
    }

    return UserResponse(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      profilePic: ProfilePic.fromJson(json['profilePic'] ?? {}),
      companyId: json['companyId'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      prefix: json['prefix'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profilePic': profilePic.toJson(),
      'companyId': companyId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'prefix': prefix,
    };
  }
}

class ProfileResponse {
  final int id;
  final String fullName;
  ProfilePic? profilePic;
  final String firstName;
  final String lastName;
  final String prefix;
  final String email;
  final String gender;

  ProfileResponse({
    required this.id,
    required this.fullName,
    this.profilePic,
    required this.email,
    required this.firstName,
    required this.gender,
    required this.lastName,
    required this.prefix,
  });

  factory ProfileResponse.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      throw ArgumentError(
          'Expected a Map<String, dynamic>, but got: ${json.runtimeType}');
    }

    return ProfileResponse(
      id: json['id'] as int? ?? 0,
      fullName: json['fullName'] as String? ?? '',
      profilePic: ProfilePic.fromJson(json['profilePic'] ?? {}),
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      prefix: json['prefix'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profilePic': profilePic?.toJson(),
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'prefix': prefix,
    };
  }
}
