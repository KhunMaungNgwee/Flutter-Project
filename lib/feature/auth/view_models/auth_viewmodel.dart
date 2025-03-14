import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/services/api/api_service.dart';
import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/feature/auth/models/user_response.dart';

class AuthViewModel extends ChangeNotifier {
  final ApiService _apiService;
  final SharedPreferencesService _sharedPreferencesService;

  bool _isLoading = false;
  bool _rememberMe = false;
  String? _abbreviation;
  String? _fullName;
  String? _password;
  bool _isAuthenticated = false;
  UserResponse? _user;

  bool get isLoading => _isLoading;
  bool get rememberMe => _rememberMe;
  String? get abbreviation => _abbreviation;
  String? get fullName => _fullName;
  String? get password => _password;
  bool get isAuthenticated => _isAuthenticated;
  UserResponse? get user => _user;

  AuthViewModel({
    required ApiService apiService,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiService = apiService,
        _sharedPreferencesService = sharedPreferencesService {
    _loadSavedCredentials();
  }

  Future<void> setRememberMe(bool rememberMe) async {
    _rememberMe = rememberMe;
    notifyListeners();
    if (!rememberMe) {
      await _clearSavedCredentials();
    }
  }

  Future<void> _loadSavedCredentials() async {
    await _sharedPreferencesService.init();
    _rememberMe = _sharedPreferencesService.getBool('rememberMe') ?? false;

    if (_rememberMe) {
      _abbreviation = _sharedPreferencesService.getString('abbreviation');
      _fullName = _sharedPreferencesService.getString('fullName');
      _password = _sharedPreferencesService.getString('password');
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
    }
    notifyListeners();
  }

  Future<void> _saveCredentials(
      String abbreviation, String fullName, String password) async {
    if (_rememberMe) {
      await _sharedPreferencesService.saveBool('rememberMe', true);
      await _sharedPreferencesService.saveString('abbreviation', abbreviation);
      await _sharedPreferencesService.saveString('fullName', fullName);
      await _sharedPreferencesService.saveString('password', password);

      _isAuthenticated = true;
    }
  }

  Future<void> _clearSavedCredentials() async {
    await _sharedPreferencesService.clear();
    _isAuthenticated = false;
  }

  Future<UserResponse?> login(String abbreviation, String fullName,
      String password, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data =
          await _apiService.authService.login(abbreviation, fullName, password);
      await _saveCredentials(abbreviation, fullName, password);
      _isAuthenticated = true;
      _user = UserResponse.fromJson(data);

      notifyListeners();
      GoRouter.of(context).go('/home');
    } catch (e) {
      String errorMessage = e is SocketException
          ? "Network error, please check your internet connection."
          : "Invalid credentials, please check and try again.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return _user;
  }

  void updateUserName(String prefix, String newFirstName, String newLastName,
      String gender, String email) {
    final fullName = '$prefix $newFirstName $newLastName';
    if (_user != null) {
      _user!.fullName = fullName;
      _user!.firstName = newFirstName;
      _user!.lastName = newLastName;
      _user!.prefix = prefix;
      _user!.gender = gender;
      _user!.email = email;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _clearSavedCredentials();
    _isAuthenticated = false;
    notifyListeners();
  }
}
