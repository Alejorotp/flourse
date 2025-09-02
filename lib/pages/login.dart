import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  static const String id = '/login';
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

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
                _textFieldUsername(auth),
                SizedBox(height: 8),
              ],
              _textFieldEmail(auth),
              SizedBox(height: 8),
              _textFieldPassword(auth),
              SizedBox(height: 25),
              _buttonLogReg(auth),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldUsername(final auth) {
    return _TextFieldGeneral(
      labelText: "Username",
      onChanged: (v) => auth.userName.value = v,
    );
  }

  Widget _textFieldEmail(final auth) {
    return _TextFieldGeneral(
      labelText: "Email",
      onChanged: (value) => auth.email.value = value,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _textFieldPassword(final auth) {
    return _TextFieldGeneral(
      labelText: "Password",
      onChanged: (value) => auth.password.value = value,
      obscureText: true,
    );
  }

  Widget _buttonLogReg(final auth) {
    return Obx(
      () => ElevatedButton(
        onPressed: () {
          String? error;
          if (auth.isLogin.value) {
            error = auth.login(auth.email.value, auth.password.value);
          } else {
            error = auth.register(
              auth.userName.value,
              auth.email.value,
              auth.password.value,
            );
          }

          if (error == null) {
            // Éxito → ir a home
            Get.offNamed('/home');
          } else {
            // Mostrar error
            Get.snackbar("Error", error, snackPosition: SnackPosition.BOTTOM);
          }
        },
        child: Text(auth.isLogin.value ? "Login" : "Register"),
      ),
    );
  }
}

class _TextFieldGeneral extends StatelessWidget {
  /*const _TextFieldGeneral({
    super.key,
  });*/
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
