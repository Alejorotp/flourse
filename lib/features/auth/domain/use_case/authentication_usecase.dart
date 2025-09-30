import '../models/authentication_user.dart';
import '../repositories/i_auth_repository.dart';

class AuthenticationUseCase {
  final IAuthRepository _repository;

  AuthenticationUseCase(this._repository);

  Future<Set<dynamic>> login(String email, String? password) async => await _repository
      .login(AuthenticationUser(email: email, name: email, password: password));

  Future<bool> signUp(String email, String? password, String userName) async =>
      await _repository.signUp(
        AuthenticationUser(email: email, name: userName, password: password),
      );

  Future<bool> validate(String email, String validationCode) async =>
      await _repository.validate(email, validationCode);

  Future<bool> logOut() async => await _repository.logOut();

  Future<bool> validateToken(String accessToken) async => await _repository.validateToken(accessToken);

  Future<void> forgotPassword(String email) async =>
      _repository.forgotPassword(email);
}
