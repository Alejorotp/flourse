import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';
import 'package:loggy/loggy.dart';

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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final userNameController = TextEditingController();

  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  static const blue = Color.fromRGBO(43, 213, 243, 1); // celeste

  void _clearAllFields() {
    emailController.clear();
    passwordController.clear();
    userNameController.clear();
    email = '';
    password = '';
    userName = '';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationController auth = Get.find();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F4FA), // fondo fijo
      body: Center(
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  child: Icon(
                    Icons.school,
                    size: 60,
                    color: auth.isLogin.value ? lilac : blue, // animado
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "FLOURSE",
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Una app en flutter para administrar cursos",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                const SizedBox(height: 25),

                // Tabs Login / Register
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildTabButton(
                            "Iniciar sesión",
                            auth.isLogin.value,
                            () {
                              _clearAllFields();
                              auth.isLogin.value = true;
                            },
                            isLogin: true,
                            auth: auth,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _buildTabButton(
                            "Registrarse",
                            !auth.isLogin.value,
                            () {
                              _clearAllFields();
                              auth.isLogin.value = false;
                            },
                            isLogin: false,
                            auth: auth,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                _textFieldEmail(),
                const SizedBox(height: 12),
                _textFieldPassword(),
                const SizedBox(height: 12),
                if (!auth.isLogin.value) ...[
                  _textFieldUsername(),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 30),
                _buttonLogReg(auth),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    String text,
    bool isActive,
    VoidCallback onTap, {
    required bool isLogin,
    required AuthenticationController auth,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? (isLogin ? lilac : blue) // 🔹 se decide según el modo
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _textFieldUsername() {
    return _TextFieldGeneral(
      labelText: "Nombre de usuario",
      controller: userNameController,
      onChanged: (value) => userName = value,
    );
  }

  Widget _textFieldEmail() {
    return _TextFieldGeneral(
      labelText: "Correo electrónico",
      controller: emailController,
      onChanged: (value) => email = value,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _textFieldPassword() {
    return _TextFieldGeneral(
      labelText: "Contraseña",
      controller: passwordController,
      onChanged: (value) => password = value,
      obscureText: true,
    );
  }

  void _onLoginAction(AuthenticationController auth, bool stayLoggedIn) async {
    try {
      if (stayLoggedIn) {
        logInfo("El usuario eligió mantener la sesión iniciada.");
        auth.rememberMe = true;
      } else {
        auth.rememberMe = false;
      }
      await auth.login(email, password);
      Get.snackbar(
        "Éxito",
        "Inicio de sesión exitoso",
        icon: const Icon(Icons.check_circle, color: Colors.green),
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (err) {
      Get.snackbar(
        "Error",
        err.toString(),
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Widget _buttonLogReg(final auth) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: auth.isLogin.value ? lilac : blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
          ),
          onPressed: () async {
            if (auth.isLogin.value!) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Mantener sesión iniciada"),
                    content:
                        const Text("¿Deseas mantener la sesión iniciada?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _onLoginAction(auth, true);
                        },
                        child: const Text("Sí"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _onLoginAction(auth, false);
                        },
                        child: const Text("No"),
                      ),
                    ],
                  );
                },
              );
            } else {
              if (email.isEmpty || password.isEmpty || userName.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Todos los campos son obligatorios",
                  icon: const Icon(Icons.error, color: Colors.red),
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              try {
                await auth.signUp(email, password, userName);
                Get.snackbar(
                  "Éxito",
                  "Usuario creado exitosamente",
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  snackPosition: SnackPosition.BOTTOM,
                );
                _clearAllFields();
                auth.isLogin.value = true;
              } catch (err) {
                Get.snackbar(
                  "Error",
                  err.toString(),
                  icon: const Icon(Icons.error, color: Colors.red),
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }
          },
          child: Text(
            auth.isLogin.value ? "Iniciar sesión" : "Registrarse",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}

class _TextFieldGeneral extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) onChanged;
  final TextInputType keyboardType;
  final bool obscureText;

  const _TextFieldGeneral({
    required this.labelText,
    required this.controller,
    required this.onChanged,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: labelText,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.deepPurpleAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Colors.deepPurpleAccent, width: 2),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
