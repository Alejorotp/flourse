import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

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

  Widget _buttonLogReg(final auth) {
    return Obx(
      () => ElevatedButton(
        onPressed: () async {
          if (auth.isLogin.value!) {
            try {
              await auth.login(email, password);
            } catch (err) {
              Get.snackbar(
                "Login",
                err.toString(),
                icon: const Icon(Icons.person, color: Colors.red),
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          } else {
            try {
              await auth.register(
                email,
                userName,
                password,
              );
            } catch (err) {
              Get.snackbar(
                "Login",
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
