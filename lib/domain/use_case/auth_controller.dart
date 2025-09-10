import 'package:get/get.dart';
import '../../features/auth/domain/models/authentication_user.dart';
import 'package:uuid/uuid.dart';
import 'package:flourse/data/data.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var currentUser = Rxn<AuthenticationUser>();

  // Variables observables para los campos del formulario
  var userName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

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

  String? register(String name, String mail, String pass) {
    String? validationError = validateFields(mail, pass, name: name);
    if (validationError != null) {
      return validationError;
    }
    if (fakeUsers.containsKey(mail)) {
      return "El usuario ya existe";
    }
    final uuid = Uuid();
    final user = AuthenticationUser(
      id: int.parse(uuid.v4()),
      name: name,
      email: mail,
      password: pass,
    );
    fakeUsers[mail] = user;
    currentUser.value = user;
    return null;
  }

  String? login(String mail, String pass) {
    String? validationError = validateFields(mail, pass);
    if (validationError != null) {
      return validationError;
    }
    final user = fakeUsers[mail];
    if (user == null) {
      return "Usuario no encontrado";
    }
    if (user.password != pass) {
      return "Contraseña incorrecta";
    }
    currentUser.value = user;
    return null;
  }

  void logout() {
    currentUser.value = null;
  }
}
