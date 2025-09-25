import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../domain/models/authentication_user.dart';
import '../i_authentication_source.dart';
import 'dart:io';
import 'authentication_client.dart';

class AuthenticationSourceService implements IAuthenticationSource {
  //final http.Client httpClient;
  final AuthenticatedClient client;
  //String? _refreshToken;

  //AuthenticationSourceService({http.Client? client})
  //  : httpClient = client ?? http.Client();
  AuthenticationSourceService(this.client);

  @override
  Future<Set<dynamic>> login(AuthenticationUser user) async {
    logInfo("Attempting login for email: ${user.email}");
    try {
      final response = await client.post(
        Uri.parse("https://roble-api.openlab.uninorte.edu.co/auth/flourse_460df99409/login"),
        body: {
          'email': user.email,
          'password': user.password,
        },
      );
      logInfo("Login response status: ${response.statusCode}");
      logInfo("Login response body: ${response.body}");
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Guardar tokens en el client
      client.updateTokens(
        accessToken: responseData['accessToken'],
        refreshToken: responseData['refreshToken'],
      );
      
      // Guardar el refresh token localmente si es necesario
      final authUser = {AuthenticationUser(email: responseData['user']['email'], name: responseData['user']['name'], id: responseData['user']['id'], password: user.password), responseData['accessToken'], responseData['refreshToken']};

      try {
        final responseQuery = await client.get(
          Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/read?tableName=AuthenticationUser&UID=${responseData['user']['id']}"),
          headers: {
            'Authorization': 'Bearer ${responseData['accessToken']}',
          },
        );
        logInfo("User data fetch response status: ${responseQuery.statusCode}");
        logInfo("User data fetch response body: ${responseQuery.body}");
        if (responseQuery.body.isNotEmpty) {
          final responseCreateUser = await client.post(
            Uri.parse("https://roble-api.openlab.uninorte.edu.co/database/flourse_460df99409/insert"),
            headers: {
              'Authorization': 'Bearer ${responseData['accessToken']}',
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'tableName': 'AuthenticationUser',
              'records': [
                {
                  'UID': responseData['user']['id'],
                  'name': responseData['user']['name'],
                  'email': responseData['user']['email'],
                },
              ],
          }),
          );
          logInfo("User creation response status: ${responseCreateUser.statusCode}");
          logInfo("User creation response body: ${responseCreateUser.body}");
        }
      } catch (e) {
        logError("Error during user data fetch: $e");
      }
      return authUser;
    } catch (e) {
      logError("Error during login: $e");
      return {};
    }
  }

  @override
  Future<bool> signUp(AuthenticationUser user) async {
    logInfo("Attempting sign up for email: ${user.email}");
    try {
    final response = await client.post(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/auth/flourse_460df99409/signup-direct"),
      body: {
        'email': user.email,
        'name': user.name,
        'password': user.password,
      },
    );
    logInfo("Sign up response status: ${response.statusCode}");
    logInfo("Sign up response body: ${response.body}");
    return response.statusCode == 201;
  } catch (e) {
    logError("Error during sign up: $e");
    return false;
  }
  }

  @override
  Future<bool> logOut() async {
    logInfo("Attempting logout");
    client.updateTokens(accessToken: '', refreshToken: '');
    return Future.value(true);
  }

  @override
  Future<bool> validate(String email, String validationCode) async {
    logInfo("Attempting email validation for email: $email");
    return Future.value(true);
  }

  @override
  Future<String?> refreshToken(String rToken) async {
    logInfo("Attempting token refresh");
    try {
    final response = await http.post(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/auth/flourse_460df99409/refresh-token"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'refreshToken': rToken,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final newAccessToken = jsonResponse['accessToken'];
      if (newAccessToken != null) {
        return newAccessToken as String;
      }
    }
  } on SocketException catch (e) {
    // Manejar errores de conexión a internet.
    logError('Error de conexión: $e');
  } on HttpException catch (e) {
    // Manejar otros errores HTTP.
    logError('Error HTTP: $e');
  } catch (e) {
    // Manejar cualquier otro error inesperado.
    logError('Error inesperado: $e');
  }

  return null;
  }

  @override
  Future<bool> forgotPassword(String email) async {
    logInfo("Attempting password reset for email: $email");
    return Future.value(true);
  }

  @override
  Future<bool> resetPassword(
    String email,
    String newPassword,
    String validationCode,
  ) async {
    return Future.value(true);
  }

  @override
  Future<bool> verifyToken(String accessToken) async {
    logInfo("Attempting token verification");
    final response = await client.get(
      Uri.parse("https://roble-api.openlab.uninorte.edu.co/auth/flourse_460df99409/verify-token"),
    );
    return response.statusCode == 201;
  }
}
