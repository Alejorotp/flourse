import 'package:get/get.dart';

class AuthController extends GetxController {
  // Estado
  var isLogin = true.obs; // alterna entre login y registro
  var userName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  // Simulación de base de datos en memoria
  final _fakeUsers = <String, String>{}; // email: password
  final _fakeNames = <String, String>{}; // email: name

  // Cambiar entre login y registro
  void toggleForm() {
    isLogin.value = !isLogin.value;
  }

  String? validateFields(String mail, String pass, {String? name}) {
    if (mail.trim().isEmpty || pass.trim().isEmpty) {
      return "El email y la contraseña no pueden estar vacíos";
    }
    if (name != null && name.trim().isEmpty) {
      return "El nombre de usuario no puede estar vacío";
    }
    return null;
  }

  // Registro
  String? register(String name, String mail, String pass) {
    String? validationError = validateFields(mail, pass, name: name);
    if (validationError != null) {
      return validationError;
    }

    if (_fakeUsers.containsKey(mail)) {
      return "El usuario ya existe";
    }
    _fakeUsers[mail] = pass;
    _fakeNames[mail] = name;
    userName.value = name;
    email.value = mail;
    password.value = pass;
    return null; // éxito
  }

  // Login
  String? login(String mail, String pass) {
    String? validationError = validateFields(mail, pass);
    if (validationError != null) {
      return validationError;
    }
    
    if (!_fakeUsers.containsKey(mail)) {
      return "Usuario no encontrado";
    }
    if (_fakeUsers[mail] != pass) {
      return "Contraseña incorrecta";
    }
    userName.value = _fakeNames[mail] ?? "";
    email.value = mail;
    password.value = pass;
    return null; // éxito
  }

  // Cerrar sesión
  void logout() {
    userName.value = '';
    email.value = '';
    password.value = '';
  }
}
