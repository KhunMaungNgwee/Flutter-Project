import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/feature/auth/view_models/auth_viewmodel.dart';
import 'package:todo/feature/home/models/content_response.dart';

class HomeViewModel extends ChangeNotifier {
  final ApiService _apiService;
  List<ContentResponse>? _contents;
  List<ContentResponse>? get contents => _contents;

  HomeViewModel({
    required ApiService apiService,
  }) : _apiService = apiService;

  Future<void> allContents(
      int userId, String companyId, BuildContext context) async {
    try {
      final data =
          await _apiService.homeService.getAllContents(userId, companyId);
      print(data);
      if (data is List) {
        _contents = data.map((item) => ContentResponse.fromJson(item)).toList();
      }
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
}
