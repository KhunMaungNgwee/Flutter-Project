import 'package:todo/core/utils/shared_preferences.dart';
import 'package:todo/core/services/api/api_manager.dart';

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
  Future<dynamic> getAllContents(int userId, String companyId) async {
    final response = await _apiManager.makeApiCall(
      endpoint: 'Contents/GetAllContents',
      callType: ApiCallType.GET,
      params: {'UserID': userId.toString(), 'CompanyId': companyId},
      version: 'v5',
      requiresAuth: true,
    );

    if (response['status'] == 0) {
      final data = response['data'];
      print("hello,,,,,,,,,,,,,");
      print(data);
      return data;
    } else {
      throw Exception("Login failed: ${response['message']}");
    }
  }
}
