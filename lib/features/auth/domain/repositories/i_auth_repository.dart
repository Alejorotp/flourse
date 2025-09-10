import '../models/authentication_user.dart';

abstract class IAuthRepository {
  Future<AuthenticationUser?> login(AuthenticationUser user);

  Future<bool> signUp(AuthenticationUser user);

  Future<bool> logOut();

  Future<bool> validate(String email, String validationCode);

  Future<bool> validateToken();

  Future<void> forgotPassword(String email);
}
