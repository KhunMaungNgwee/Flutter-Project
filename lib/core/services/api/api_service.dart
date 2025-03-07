import 'package:flutter/material.dart';
import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/core/services/api/api_manager.dart';
import 'package:todo/feature/auth/models/user_response.dart';
import 'package:todo/feature/home/models/content_response.dart';

class ApiService {
  final AuthService authService;
  final HomeService homeService;

  ApiService(
      ApiManager apiManager, SharedPreferencesService sharedPreferencesService)
      : authService = AuthService(apiManager, sharedPreferencesService),
        homeService = HomeService(apiManager, sharedPreferencesService);
}

class AuthService {
  final ApiManager _apiManager;
  final SharedPreferencesService _preferencesService;

  AuthService(this._apiManager, this._preferencesService);
  Future<dynamic> login(
      String abbreviation, String fullName, String password) async {
    final response = await _apiManager.makeApiCall(
      endpoint: 'Login/LoginCustomerUserview',
      callType: ApiCallType.POST,
      body: {
        'abbreviation': abbreviation,
        'fullName': fullName,
        'password': password,
      },
      requiresAuth: false,
    );

    if (response['status'] == 0) {
      final data = response['data'];
      await _preferencesService.saveString(
          "jwt_token", response['data']['token']);
      return data;
    } else {
      throw Exception("Login failed: ${response['message']}");
    }
  }
}

class HomeService {
  final ApiManager _apiManager;
  final SharedPreferencesService _preferencesService;

  HomeService(this._apiManager, this._preferencesService);
  Future<List<ContentModel>> getAllContents(
      int userId, String companyId) async {
    final response = await _apiManager.makeApiCall(
      endpoint: 'Contents/GetAllContents',
      callType: ApiCallType.GET,
      params: {'UserID': userId.toString(), 'CompanyId': companyId},
      version: 'v5',
      requiresAuth: true,
    );
    if (response['status'] == 0) {
      final List<dynamic> data = response['data'];

      final List<ContentModel> contentData =
          data.map((content) => ContentModel.fromJson(content)).toList();
      print(contentData);
      return contentData;
    } else {
      throw Exception("Login failed: ${response['message']}");
    }
  }

  // Future<List<UserResponse>> updateProfile() async {
  //   final response = await _apiManager.makeApiCall(
  //     endpoint: "User/UpdateUserProfileWeb",
  //     callType: ApiCallType.POST,
  //     version: 'V1',
  //     requiresAuth: true,
  //   );
  //   if (response['status'] == 0) {
  //     return response;
  //   }
  // }
  Future<bool> updateUserProfile(ProfileResponse payload) async {
    debugPrint(
        "Sending payload to API: ${payload.toJson()}"); // ✅ Add this line

    final response = await _apiManager.makeApiCall(
      endpoint: '/User/UpdatedUserFromMobile',
      callType: ApiCallType.POST,
      body: payload.toJson(),
      version: 'v1',
      requiresAuth: true,
    );

    debugPrint("API Response: $response"); // ✅ Log the API response

    if (response['status'] == 0) {
      return true;
    } else {
      throw Exception("Profile update failed: ${response['message']}");
    }
  }

  Future<dynamic> getUserProfilePic(int userID) async {
    final response = await _apiManager.makeApiCall(
        endpoint: 'User/GetUserProfilePic',
        callType: ApiCallType.GET,
        version: 'v1',
        requiresAuth: true,
        params: {
          "UserID": userID.toString(),
        });
    if (response['status'] == 0) {
      return response['data'];
    } else {
      throw Exception("Fetching Data Failed: ${response['message']}");
    }
  }
}
