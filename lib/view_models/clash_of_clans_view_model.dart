import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClashOfClansViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _playerData;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get playerData => _playerData;

  Future<void> fetchPlayerData(String playerTag) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _playerData = await _apiService.fetchClashOfClansPlayer(playerTag);
    } catch (e) {
      _playerData = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
