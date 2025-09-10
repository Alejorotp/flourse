import 'package:flourse/features/auth/domain/models/authentication_user.dart';
import 'package:get/get.dart';

import 'package:loggy/loggy.dart';

import '../../domain/use_case/authentication_usecase.dart';

class AuthenticationController extends GetxController {
  final AuthenticationUseCase authentication;
  final logged = false.obs;
  var isLogin = true.obs;
  Rx<AuthenticationUser> currentUser = AuthenticationUser(email: '', name: '', password: '').obs;

  AuthenticationController(this.authentication);

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
  }

  bool get isLogged => logged.value;

  String? validateFields(String mail, String pass, {String? name}) {
    if (mail.trim().isEmpty || pass.trim().isEmpty) {
      return "El email y la contraseña no pueden estar vacíos";
    }
    if (name != null && name.trim().isEmpty) {
      return "El nombre de usuario no puede estar vacío";
    }
    return null;
  }

  void toggleForm() {
    isLogin.value = !isLogin.value;
  }

  Future<AuthenticationUser?> login(email, password) async {
    logInfo('AuthenticationController: Login $email $password');
    String? validationError = validateFields(email, password);
    if (validationError != null) {
      logWarning('AuthenticationController: Login failed - $validationError');
      return null;
    }
    var rta = await authentication.login(email, password);
    logged.value = rta != null;
    if (rta != null) {
      currentUser.value = rta;
    }
    return rta;
  }

  Future<bool> signUp(email, password, userName) async {
    logInfo('AuthenticationController: Sign Up $email $password $userName');
    String? validationError = validateFields(email, password, name: userName);
    if (validationError != null) {
      logWarning('AuthenticationController: Sign Up failed - $validationError');
      return false;
    }
    await authentication.signUp(email, password, userName);
    
    return validationError == null;
  }

  Future<void> logOut() async {
    logInfo('AuthenticationController: Log Out');
    await authentication.logOut();
    logged.value = false;
    //currentUser.value = AuthenticationUser(email: '', name: '', password: '');
  }
}
