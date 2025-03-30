import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class ApiService {
  final String clientId = "YOUR_CLIENT_ID"; // Replace with your client ID
  final String clientSecret =
      "YOUR_CLIENT_SECRET"; // Replace with your client secret
  final String redirectUri =
      "http://local.example.com:3000/oauth2-callback"; // Replace with your redirect URI
  final String apiKey = "RGAPI-59331d99-dad5-42b6-a769-1be8502f3565";
  final String brawlStarsToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjNlYjgzYjQzLTNmMTUtNGU0Ny1iN2EzLTY4ZTA5Zjg0ZTk2ZSIsImlhdCI6MTc0MzM0ODA4Nywic3ViIjoiZGV2ZWxvcGVyL2Y2YmQ5YzU5LTJiZjUtYTM4NC0xM2MwLTk0MWUyOGMyNThmZSIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTk2LjE4OC4xNjAuMTExIl0sInR5cGUiOiJjbGllbnQifV19._e4D3UyKTsqVjD4FFP1m43kXGtPj7pB_SlWrtLqve5g2Evq30tCw6pttHpmu6iEdILTLYWPbtfq9J9vuwV2AiQ";

  Future<void> initiateRSOLogin() async {
    final authUrl = Uri.parse(
      "https://auth.riotgames.com/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code&scope=openid+offline_access",
    );

    log('Client ID: $clientId');
    log('Redirect URI: $redirectUri');
    log('Authorization URL: $authUrl');

    log('Attempting to launch URL: $authUrl');
    if (await canLaunchUrl(authUrl)) {
      await launchUrl(authUrl, mode: LaunchMode.externalApplication);
    } else {
      log('Could not launch URL: $authUrl');
      throw Exception('Could not launch RSO login URL');
    }
  }

  Future<Map<String, dynamic>> exchangeCodeForTokens(String code) async {
    final url = Uri.parse("https://auth.riotgames.com/token");
    log('Authorization Code: $code');
    log('Exchanging code for tokens at: $url');
    log(
      'Request Headers: ${{HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded', HttpHeaders.authorizationHeader: 'Basic ' + base64Encode(utf8.encode("$clientId:$clientSecret"))}}',
    );
    log(
      'Request Body: ${{'grant_type': 'authorization_code', 'code': code, 'redirect_uri': redirectUri}}',
    );
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader:
            'Basic ' + base64Encode(utf8.encode("$clientId:$clientSecret")),
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code,
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to exchange code for tokens');
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo(String accessToken) async {
    final url = Uri.parse("https://auth.riotgames.com/userinfo");
    final response = await http.get(
      url,
      headers: {HttpHeaders.authorizationHeader: 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<Map<String, dynamic>> refreshAccessToken(String refreshToken) async {
    final url = Uri.parse("https://auth.riotgames.com/token");
    final response = await http.post(
      url,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
        HttpHeaders.authorizationHeader:
            'Basic ' + base64Encode(utf8.encode("$clientId:$clientSecret")),
      },
      body: {'grant_type': 'refresh_token', 'refresh_token': refreshToken},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to refresh access token');
    }
  }

  Future<Map<String, dynamic>> fetchAccountDetails(
    String gameName,
    String tagLine,
  ) async {
    final encodedGameName = Uri.encodeComponent(gameName);
    final encodedTagLine = Uri.encodeComponent(tagLine);
    final url = Uri.parse(
      "https://api.riotgames.com/riot/account/v1/accounts/by-riot-id/$encodedGameName/$encodedTagLine",
    );

    final response = await http.get(
      url,
      headers: {
        HttpHeaders.authorizationHeader:
            'Bearer YOUR_ACCESS_TOKEN', // Replace with a valid access token
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch account details: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchUserStats() async {
    final url = Uri.parse(
      "https://americas.api.riotgames.com/riot/account/v1/accounts/me",
    );

    final response = await http.get(url, headers: {'X-Riot-Token': apiKey});

    log('Request URL: $url');
    log('Request Headers: ${{'X-Riot-Token': apiKey}}');
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user stats: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchRecentMatches(String queue) async {
    final url = Uri.parse(
      "https://americas.api.riotgames.com/val/match/v1/recent-matches/by-queue/$queue",
    );

    final response = await http.get(url, headers: {'X-Riot-Token': apiKey});

    log('Request URL: $url');
    log('Request Headers: ${{'X-Riot-Token': apiKey}}');
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch recent matches: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchBrawlStarsPlayer(String playerTag) async {
    final encodedTag = Uri.encodeComponent(playerTag);
    final url = Uri.parse("https://api.brawlstars.com/v1/players/$encodedTag");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $brawlStarsToken'},
    );

    log('Request URL: $url');
    log('Request Headers: ${{'Authorization': 'Bearer $brawlStarsToken'}}');
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch Brawl Stars player: ${response.body}');
    }
  }

  final String clashOfClansToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjE0ZDU4YmUyLTU5YzAtNDQ3Mi1iNzJmLWQxOGI3Y2E0MWVmYyIsImlhdCI6MTc0MzM0ODE2NSwic3ViIjoiZGV2ZWxvcGVyLzAwMjU2NWUxLTNlNWEtNzE2Ni1kZGVkLTk4MjJjNzdkODI5MSIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE5Ni4xODguMTYwLjExMSJdLCJ0eXBlIjoiY2xpZW50In1dfQ.eDGPHcWh4FtBvNYjhdFYJaV_EWxa42KR5Uf9nu9hlenAkSnHyY2M2qOm3EsdcIfompUxE5p4Dqd-Df4hcPWyRg";

  Future<Map<String, dynamic>> fetchClashOfClansPlayer(String playerTag) async {
    final encodedTag = Uri.encodeComponent(playerTag);
    final url = Uri.parse(
      "https://api.clashofclans.com/v1/players/$encodedTag",
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $clashOfClansToken'},
    );

    log('Request URL: $url');
    log('Request Headers: ${{'Authorization': 'Bearer $clashOfClansToken'}}');
    log('Response Status Code: ${response.statusCode}');
    log('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'Failed to fetch Clash of Clans player: ${response.body}',
      );
    }
  }
}
