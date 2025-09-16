import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;
import '../../../domain/models/authentication_user.dart';
import 'i_authentication_source.dart';
import '../../../../../../data/data.dart';

class AuthenticationSourceService implements IAuthenticationSource {
  final http.Client httpClient;

  AuthenticationSourceService({http.Client? client})
    : httpClient = client ?? http.Client();

  @override
  Future<AuthenticationUser?> login(AuthenticationUser user) async {
    logInfo("Attempting login for email: ${user.email}");
    final userProvider = fakeUsers[user.email];
    if (userProvider == null) {
      return Future.value(null);
    }
    if (userProvider.password != user.password) {
      return Future.value(null);
    }
    return Future.value(userProvider);
  }

  @override
  Future<bool> signUp(AuthenticationUser user) async {
    logInfo("Attempting sign up for email: ${user.email}");
    if (fakeUsers.containsKey(user.email)) {
      return Future.value(false);
    }
    fakeUsers[user.email] = user;
    for (var key in fakeUsers.keys) {
      logInfo("User in system: $key");
    }
    return Future.value(true);
  }

  @override
  Future<bool> logOut() async {
    logInfo("Attempting logout");
    return Future.value(true);
  }

  @override
  Future<bool> validate(String email, String validationCode) async {
    logInfo("Attempting email validation for email: $email");
    return Future.value(true);
  }

  @override
  Future<bool> refreshToken() async {
    logInfo("Attempting token refresh");
    return Future.value(true);
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
  Future<bool> verifyToken() async {
    logInfo("Attempting token verification");
    return Future.value(true);
  }
}
