import '../../../domain/models/authentication_user.dart';

abstract class IAuthenticationSource {
  Future<AuthenticationUser?> login(AuthenticationUser user);

  Future<bool> signUp(AuthenticationUser user);

  Future<bool> logOut();

  Future<bool> validate(String email, String validationCode);

  Future<bool> refreshToken();

  Future<bool> forgotPassword(String email);

  Future<bool> resetPassword(
    String email,
    String newPassword,
    String validationCode,
  );

  Future<bool> verifyToken();
}
