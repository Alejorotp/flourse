import 'package:flourse/features/auth/domain/models/authentication_user.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:loggy/loggy.dart';

import '../../domain/use_case/authentication_usecase.dart';

class AuthenticationController extends GetxController {
  final AuthenticationUseCase authentication;
  final logged = false.obs;
  var isLogin = true.obs;
  Rx<AuthenticationUser> currentUser = AuthenticationUser(id: '', email: '', name: '', password: '').obs;
  var accessToken = ''.obs;
  var refreshToken = ''.obs;
  bool rememberMe = true;

  AuthenticationUser lastUser = AuthenticationUser(id: '', email: '', name: '', password: '');
  SharedPreferences? prefs;

  AuthenticationController(this.authentication);

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
    prefs = await SharedPreferences.getInstance();
    rememberMe = prefs?.getBool('rememberMe') ?? false;
    logInfo('Remember me from prefs: $rememberMe, prefs: ${prefs?.getBool('rememberMe')}');
    if (rememberMe) {
      lastUser = AuthenticationUser(
        email: prefs?.getString('lastUserEmail') ?? '',
        name: '',
        password: prefs?.getString('lastUserPassword') ?? '',
      );
      accessToken.value = prefs?.getString('accessToken') ?? '';
      refreshToken.value = prefs?.getString('refreshToken') ?? '';
    }
    logInfo('Remember me: $rememberMe, Last user: ${lastUser.email}');
    logInfo('Access token: ${accessToken.value}, Refresh token: ${refreshToken.value}');

    if (rememberMe && lastUser.email.isNotEmpty) {
      logError('Logging in with remembered user: ${lastUser.email}');
      logError('Access token: ${accessToken.value}, Refresh token: ${refreshToken.value}');
      logError('Last user password: ${lastUser.password}');
      var rta = await authentication.login(lastUser.email, lastUser.password);
      logged.value = rta.isNotEmpty;
      if (rta.isNotEmpty) {
        currentUser.value = rta.first;
      }
    } else {
      logged.value = await authentication.validateToken(accessToken.value);
    }
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

  Future<Set<dynamic>> login(email, password) async {
    prefs ??= await SharedPreferences.getInstance();

    logInfo('AuthenticationController: Login $email $password');
    String? validationError = validateFields(email, password);
    if (validationError != null) {
      logWarning('AuthenticationController: Login failed - $validationError');
      return {};
    }

    var rta = await authentication.login(email, password);
    logged.value = rta.isNotEmpty;
    if (rta.isNotEmpty) {
      currentUser.value = rta.first;
      accessToken.value = rta.elementAt(1) ?? '';
      refreshToken.value = rta.elementAt(2) ?? '';

      // 🔹 Set rememberMe here or from the UI
      rememberMe = true;

      if (rememberMe) {
        logInfo('AuthenticationController: Remember me is enabled');
        lastUser = rta.first;

        try {
          await prefs!.setBool('rememberMe', true);
          await prefs!.setString('lastUserEmail', lastUser.email);
          await prefs!.setString('lastUserPassword', lastUser.password ?? '');
          await prefs!.setString('accessToken', accessToken.value);
          await prefs!.setString('refreshToken', refreshToken.value);

          logInfo('AuthenticationController: User logged in - ${currentUser.value.email}');
          logInfo('Access token: ${accessToken.value}, Refresh token: ${refreshToken.value}');
        } catch (e, st) {
          logError('Error saving SharedPreferences: $e\n$st');
        }
      } else {
        logInfo('AuthenticationController: Remember me is disabled');
        await prefs!.setBool('rememberMe', false);
        await prefs!.remove('lastUserEmail');
        await prefs!.remove('lastUserPassword');
        await prefs!.remove('accessToken');
        await prefs!.remove('refreshToken');
      }
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
    rememberMe = false;
  }
}
