import 'package:get/get.dart';
import '../models/user.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController {
  var isLogin = true.obs;
  var currentUser = Rxn<User>();

  // Variables observables para los campos del formulario
  var userName = ''.obs;
  var email = ''.obs;
  var password = ''.obs;

  // Simulación de base de datos en memoria
  final _fakeUsers = <String, User>{
    // No sé que hace o porqué está ahí el primer string antes de los 2 puntos :)
    "manuel@test.com": User(
      id: "1",
      userName: "Manuel",
      email: "manuel@test.com",
      password: "123456",
    ),
    "ana@test.com": User(
      id: "2",
      userName: "Ana",
      email: "ana@test.com",
      password: "qwerty",
    ),
    "gaco@test.com": User(
      id: "3",
      userName: "Gaco",
      email: "gaco@test.com",
      password: "abcd",
    ),
    "none@test.com": User(
      id: "4",
      userName: "none",
      email: "none@test.com",
      password: "abcd",
    )
  };

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
    if (_fakeUsers.containsKey(mail)) {
      return "El usuario ya existe";
    }
    final uuid = Uuid();
    final user = User(
      id: uuid.v4(),
      userName: name,
      email: mail,
      password: pass,
    );
    _fakeUsers[mail] = user;
    currentUser.value = user;
    return null;
  }

  String? login(String mail, String pass) {
    String? validationError = validateFields(mail, pass);
    if (validationError != null) {
      return validationError;
    }
    final user = _fakeUsers[mail];
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
