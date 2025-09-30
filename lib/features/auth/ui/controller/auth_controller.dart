import 'package:flourse/features/auth/domain/models/authentication_user.dart';
import 'package:get/get.dart';

import 'package:flourse/core/i_local_preferences.dart';

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
  ILocalPreferences? prefs;

  AuthenticationController(this.authentication);

  @override
  Future<void> onInit() async {
    super.onInit();
    logInfo('AuthenticationController initialized');
    // ILocalPreferences is injected via Get in main.dart
    prefs = Get.find<ILocalPreferences>();
    rememberMe = (await prefs!.retrieveData<bool>('rememberMe')) ?? false;
    logInfo('Remember me from prefs: $rememberMe');
    if (rememberMe) {
      lastUser = AuthenticationUser(
        email: (await prefs!.retrieveData<String>('lastUserEmail')) ?? '',
        name: '',
        password: (await prefs!.retrieveData<String>('lastUserPassword')) ?? '',
      );
      accessToken.value = (await prefs!.retrieveData<String>('accessToken')) ?? '';
      refreshToken.value = (await prefs!.retrieveData<String>('refreshToken')) ?? '';
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
    prefs ??= Get.find<ILocalPreferences>();

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

      if (rememberMe) {
        logInfo('AuthenticationController: Remember me is enabled');
        lastUser = rta.first;

        try {
          await prefs!.storeData('rememberMe', true);
          await prefs!.storeData('lastUserEmail', lastUser.email);
          await prefs!.storeData('lastUserPassword', lastUser.password ?? '');
          await prefs!.storeData('accessToken', accessToken.value);
          await prefs!.storeData('refreshToken', refreshToken.value);

          logInfo('AuthenticationController: User logged in - ${currentUser.value.email}');
          logInfo('Access token: ${accessToken.value}, Refresh token: ${refreshToken.value}');
        } catch (e, st) {
          logError('Error saving SharedPreferences: $e\n$st');
        }
      } else {
        logInfo('AuthenticationController: Remember me is disabled');
        await prefs!.storeData('rememberMe', false);
        await prefs!.removeData('lastUserEmail');
        await prefs!.removeData('lastUserPassword');
        await prefs!.removeData('accessToken');
        await prefs!.removeData('refreshToken');
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
    await prefs!.storeData('rememberMe', false);
    await prefs!.removeData('lastUserEmail');
    await prefs!.removeData('lastUserPassword');
    await prefs!.removeData('accessToken');
    await prefs!.removeData('refreshToken');
  }
}
