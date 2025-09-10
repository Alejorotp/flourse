import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'package:loggy/loggy.dart';
import 'package:flourse/data/data.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login';
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = '';
  var password = '';
  var userName = '';

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flourse".toUpperCase(),
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "A Flutter app for course management",
                style: TextStyle(fontSize: 11),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => auth.isLogin.value = true,
                    child: Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: auth.isLogin.value ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => auth.isLogin.value = false,
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: auth.isLogin.value ? Colors.black : Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (!auth.isLogin.value) ...[
                _textFieldUsername(),
                SizedBox(height: 8),
              ],
              _textFieldEmail(),
              SizedBox(height: 8),
              _textFieldPassword(),
              SizedBox(height: 25),
              _buttonLogReg(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldUsername() {
    return _TextFieldGeneral(
      labelText: "Username",
      onChanged: (value) => userName = value,
    );
  }

  Widget _textFieldEmail() {
    return _TextFieldGeneral(
      labelText: "Email",
      onChanged: (value) => email = value,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _textFieldPassword() {
    return _TextFieldGeneral(
      labelText: "Password",
      onChanged: (value) => password = value,
      obscureText: true,
    );
  }

  // Nuevo método para manejar la lógica de login con o sin "mantener sesión"
  void _onLoginAction(AuthenticationController auth, bool stayLoggedIn) async {
    try {
      await auth.login(email, password);
      if (stayLoggedIn) {
        // --- AQUI VA LA ACCION QUE QUIERES CONFIGURAR ---
        // Ejemplo: Guardar un token o una preferencia en el dispositivo
        Loggy("El usuario eligió mantener la sesión iniciada.");
        rememberMe = true;
        // Puedes llamar a un método del controlador aquí: auth.saveLoginPreference();
      }
    } catch (err) {
      Get.snackbar(
        "Login Error",
        err.toString(),
        icon: const Icon(Icons.person, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buttonLogReg(final auth) {
    return Obx(
      () => ElevatedButton(
        onPressed: () async {
          if (auth.isLogin.value!) {
            // Mostrar la ventana emergente solo para el Login
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Mantener sesión iniciada"),
                  content: const Text("¿Deseas mantener la sesión iniciada?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _onLoginAction(auth, true); // Lógica de login + tu acción
                      },
                      child: const Text("Sí"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _onLoginAction(auth, false); // Solo la lógica de login
                      },
                      child: const Text("No"),
                    ),
                  ],
                );
              },
            );
          } else {
            // Lógica de registro sin ventana emergente
            try {
              await auth.signUp(email, password, userName);
            } catch (err) {
              Get.snackbar(
                "Register Error",
                err.toString(),
                icon: const Icon(Icons.person, color: Colors.red),
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          }
        },
        child: Text(auth.isLogin.value ? "Login" : "Register"),
      ),
    );
  }
}

class _TextFieldGeneral extends StatelessWidget {
  final String labelText;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  const _TextFieldGeneral({
    required this.labelText,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}