import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // API key for Valorant API
  final String apiKey = "RGAPI-59331d99-dad5-42b6-a769-1be8502f3565";

  // Brawl Stars token
  final String brawlStarsToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjNlYjgzYjQzLTNmMTUtNGU0Ny1iN2EzLTY4ZTA5Zjg0ZTk2ZSIsImlhdCI6MTc0MzM0ODA4Nywic3ViIjoiZGV2ZWxvcGVyL2Y2YmQ5YzU5LTJiZjUtYTM4NC0xM2MwLTk0MWUyOGMyNThmZSIsInNjb3BlcyI6WyJicmF3bHN0YXJzIl0sImxpbWl0cyI6W3sidGllciI6ImRldmVsb3Blci9zaWx2ZXIiLCJ0eXBlIjoidGhyb3R0bGluZyJ9LHsiY2lkcnMiOlsiMTk2LjE4OC4xNjAuMTExIl0sInR5cGUiOiJjbGllbnQifV19._e4D3UyKTsqVjD4FFP1m43kXGtPj7pB_SlWrtLqve5g2Evq30tCw6pttHpmu6iEdILTLYWPbtfq9J9vuwV2AiQ";

  // Clash of Clans token
  final String clashOfClansToken =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiIsImtpZCI6IjI4YTMxOGY3LTAwMDAtYTFlYi03ZmExLTJjNzQzM2M2Y2NhNSJ9.eyJpc3MiOiJzdXBlcmNlbGwiLCJhdWQiOiJzdXBlcmNlbGw6Z2FtZWFwaSIsImp0aSI6IjE0ZDU4YmUyLTU5YzAtNDQ3Mi1iNzJmLWQxOGI3Y2E0MWVmYyIsImlhdCI6MTc0MzM0ODE2NSwic3ViIjoiZGV2ZWxvcGVyLzAwMjU2NWUxLTNlNWEtNzE2Ni1kZGVkLTk4MjJjNzdkODI5MSIsInNjb3BlcyI6WyJjbGFzaCJdLCJsaW1pdHMiOlt7InRpZXIiOiJkZXZlbG9wZXIvc2lsdmVyIiwidHlwZSI6InRocm90dGxpbmcifSx7ImNpZHJzIjpbIjE5Ni4xODguMTYwLjExMSJdLCJ0eXBlIjoiY2xpZW50In1dfQ.eDGPHcWh4FtBvNYjhdFYJaV_EWxa42KR5Uf9nu9hlenAkSnHyY2M2qOm3EsdcIfompUxE5p4Dqd-Df4hcPWyRg";

  // BRAWL STARS API METHODS

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

  // CLASH OF CLANS API METHODS

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