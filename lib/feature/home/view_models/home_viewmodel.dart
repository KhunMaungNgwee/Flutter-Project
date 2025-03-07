import 'dart:io';

import 'package:flutter/material.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/feature/auth/models/user_response.dart';
import 'package:todo/feature/home/models/content_response.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<ContentModel>? _contents;
  List<ContentModel>? get contents => _contents;

  HomeViewModel({
    required ApiService apiService,
  }) : _apiService = apiService;

  Future<void> allContents(
      int userId, String companyId, BuildContext context) async {
    try {
      _contents =
          await _apiService.homeService.getAllContents(userId, companyId);
      notifyListeners();
    } catch (e) {
      String errorMessage = e is SocketException
          ? "Network error, please check your internet connection."
          : "Invalid credentials, please check and try again.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProfile(
      ProfileResponse userData, BuildContext context) async {
    try {
      debugPrint("Updating profile with: ${userData.toJson()}"); // ✅ Debug log

      await _apiService.homeService.updateUserProfile(userData);

      // ✅ Update local profile data
      userData.profilePic = ProfilePic(
        base64: userData.profilePic?.base64,
        fileName: userData.profilePic?.fileName,
        url: userData.profilePic?.url, // Keep URL if returned
      );

      notifyListeners(); // ✅ Ensure UI updates

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );
    } catch (e) {
      debugPrint("Update Profile Error: $e");
    }
  }

  Future<String> getUserProfilePic(int userID, BuildContext context) async {
    try {
      String data = await _apiService.homeService.getUserProfilePic(userID);
      notifyListeners();
      return data;
    } catch (e) {
      String errorMessage = e is SocketException
          ? "Network error"
          : "Invalid user profile api Response";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      throw Exception(e);
    } finally {
      notifyListeners();
    }
  }
}
