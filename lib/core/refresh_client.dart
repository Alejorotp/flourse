import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loggy/loggy.dart';

import '../features/auth/data/datasources/i_authentication_source.dart';
import 'i_local_preferences.dart';

class RefreshClient extends http.BaseClient {
  final http.Client _inner;
  final IAuthenticationSource _auth;

  RefreshClient(this._inner, this._auth);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final prefs = Get.find<ILocalPreferences>();
    final token = await prefs.retrieveData<String>('token');
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    Uint8List? bodyBytes;
    if (request is http.Request) {
      bodyBytes = request.bodyBytes;
    } else {
      final streamed = request.finalize();
      bodyBytes = await streamed.toBytes();
    }

    var response = await _inner.send(request);

    //Si 401, refrescamos y reintentamos
    if (response.statusCode == 401) {
      logWarning("Token expired, attempting to refresh");
      final ok = await _auth.refreshToken();
      if (ok) {
        final newToken = await prefs.retrieveData<String>('token');
        if (newToken != null) {
          final retry = http.Request(request.method, request.url)
            ..headers.addAll(request.headers)
            ..headers['Authorization'] = 'Bearer $newToken'
            ..bodyBytes = bodyBytes ?? Uint8List(0)
            ..followRedirects = request.followRedirects
            ..maxRedirects = request.maxRedirects
            ..persistentConnection = request.persistentConnection;

          return _inner.send(retry);
        }
      }
    }

    return response;
  }
}