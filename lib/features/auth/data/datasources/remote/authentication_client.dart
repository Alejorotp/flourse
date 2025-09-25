import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:loggy/loggy.dart';

class AuthenticatedClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  String? _accessToken;
  String? _refreshToken;

  void updateTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // Solo mete el Authorization si ya hay token
    if (_accessToken != null && _accessToken!.isNotEmpty) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
      logInfo(">>> AuthenticatedClient usando token: $_accessToken");
    } else {
      logInfo(">>> AuthenticatedClient sin token");
    }
    return _inner.send(request);
  }

  /// Método auxiliar para refrescar el token
  Future<bool> refreshTokenIfNeeded() async {
    if (_refreshToken == null) return false;

    final response = await _inner.post(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/auth/flourse_460df99409/refresh-token"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': _refreshToken}),
    );

    logInfo("Refresh token response status: ${response.statusCode}");
    logInfo("Refresh token response body: ${response.body}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccess = data['accessToken'];
      if (newAccess != null) {
        _accessToken = newAccess;
        return true;
      }
    }
    return false;
  }
}
