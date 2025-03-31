import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ValorantViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _accountData;
  Map<String, dynamic>? _matchData;
  List<Map<String, dynamic>> _matchDetailsList = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  Map<String, dynamic>? get accountData => _accountData;
  Map<String, dynamic>? get matchData => _matchData;
  List<Map<String, dynamic>> get matchDetailsList => _matchDetailsList;

  Future<void> fetchAccountDetails(String gameName, String tagLine) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _accountData = await _apiService.fetchValorantAccountDetails(
        gameName,
        tagLine,
      );
    } catch (e) {
      _accountData = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMatchHistory() async {
    // Can only fetch match history if we have account data with PUUID
    if (_accountData == null || !_accountData!.containsKey('puuid')) {
      _errorMessage = 'Please fetch player details first to get PUUID';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    _matchDetailsList = [];
    notifyListeners();

    try {
      final puuid = _accountData!['puuid'];
      _matchData = await _apiService.fetchValorantMatchHistory(puuid);

      // If we get match history, we can also fetch details for each match
      // But this is optional and may hit rate limits
      if (_matchData != null && _matchData!.containsKey('history')) {
        final history = _matchData!['history'] as List;

        // Limit to 3 matches to avoid rate limits
        final matchesToFetch =
            history.length > 3 ? history.sublist(0, 3) : history;

        for (var match in matchesToFetch) {
          try {
            if (match['matchId'] != null) {
              final details = await _apiService.fetchValorantMatchDetails(
                match['matchId'],
              );
              _matchDetailsList.add(details);
            }
          } catch (e) {
            // Continue even if one match fails
            print('Failed to fetch match details: $e');
          }
        }
      }
    } catch (e) {
      _matchData = null;
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
