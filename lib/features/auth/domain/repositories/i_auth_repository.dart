import '../models/authentication_user.dart';

abstract class IAuthRepository {
  Future<Set<dynamic>> login(AuthenticationUser user);

  Future<bool> signUp(AuthenticationUser user);

  Future<bool> logOut();

  Future<bool> validate(String email, String validationCode);

  Future<bool> validateToken(String accessToken);

  Future<void> forgotPassword(String email);
}
