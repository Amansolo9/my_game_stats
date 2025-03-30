import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ValorantViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _accountDetails;
  String? _accessToken;
  String? _refreshToken;
  Map<String, dynamic>? _userInfo;
  Map<String, dynamic>? _userStats;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get accountDetails => _accountDetails;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  Map<String, dynamic>? get userInfo => _userInfo;
  Map<String, dynamic>? get userStats => _userStats;

  Future<void> initiateRSOLogin() async {
    try {
      await _apiService.initiateRSOLogin();
    } catch (e) {
      // Handle any errors that occur during the login process
      print('Error during RSO login: $e');
    }
  }

  Future<void> fetchAccountDetails(String gameName, String tagLine) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _accountDetails = await _apiService.fetchAccountDetails(
        gameName,
        tagLine,
      );
    } catch (e) {
      _accountDetails = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleAuthorizationCode(String code) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final tokens = await _apiService.exchangeCodeForTokens(code);
      _accessToken = tokens['access_token'];
      _refreshToken = tokens['refresh_token'];
      _userInfo = await _apiService.fetchUserInfo(_accessToken!);
    } catch (e) {
      _accessToken = null;
      _refreshToken = null;
      _userInfo = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final tokens = await _apiService.refreshAccessToken(_refreshToken!);
      _accessToken = tokens['access_token'];
      _refreshToken = tokens['refresh_token'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserStats() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _userStats = await _apiService.fetchUserStats();
    } catch (e) {
      _userStats = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
