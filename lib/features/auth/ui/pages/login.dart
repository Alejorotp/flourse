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
  // Controllers para los campos (necesarios para limpiar)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();

  static const lilac = Color.fromRGBO(124, 77, 255, 1); // lila
  static const blue = Color.fromRGBO(43, 213, 243, 1); // celeste

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  // Limpia todos los campos y quita el foco
  void _clearAllFields() {
    emailController.clear();
    passwordController.clear();
    userNameController.clear();
    // quita el foco si había uno
    FocusScope.of(context).unfocus();
    // forzamos un rebuild por seguridad
    setState(() {});
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
                  "Flourse".toUpperCase(),
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
                    boxShadow: const [
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
                      // Al cambiar manualmente, limpiamos campos antes de cambiar el modo
                      _buildTabButton("Login", auth.isLogin.value, () {
                        _clearAllFields();
                        auth.isLogin.value = true;
                      }),
                      _buildTabButton("Sign Up", !auth.isLogin.value, () {
                        _clearAllFields();
                        auth.isLogin.value = false;
                      }),
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

  Widget _buildTabButton(String text, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? (text == "Login" ? lilac : blue) : Colors.transparent,
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
    );
  }

  Widget _textFieldEmail() {
    return _TextFieldGeneral(
      labelText: "Correo electrónico",
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _textFieldPassword() {
    return _TextFieldGeneral(
      labelText: "Contraseña",
      controller: passwordController,
      obscureText: true,
    );
  }

  // NOTA: mantengo la lógica de auth intacta; solo que ahora usamos controllers
  void _onLoginAction(AuthenticationController auth, bool stayLoggedIn) async {
    try {
      if (stayLoggedIn) {
        logInfo("El usuario eligió mantener la sesión iniciada.");
        auth.rememberMe = true;
      } else {
        auth.rememberMe = false;
      }
      await auth.login(emailController.text, passwordController.text);
      Get.snackbar(
        "Éxito",
        "Inicio de sesión exitoso",
        icon: const Icon(Icons.check_circle, color: Colors.green),
        snackPosition: SnackPosition.BOTTOM,
      );
      // limpiar campos tras login exitoso
      _clearAllFields();
    } catch (err) {
      Get.snackbar(
        "Login Error",
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
              // LOGIN: mostramos diálogo (como estaba)
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
              // SIGN UP: validación previa
              if (emailController.text.isEmpty ||
                  passwordController.text.isEmpty ||
                  userNameController.text.isEmpty) {
                Get.snackbar(
                  "Registro fallido",
                  "Todos los campos son obligatorios",
                  icon: const Icon(Icons.error, color: Colors.red),
                  snackPosition: SnackPosition.BOTTOM,
                );
                return;
              }
              try {
                await auth.signUp(
                  emailController.text,
                  passwordController.text,
                  userNameController.text,
                );
                Get.snackbar(
                  "Éxito",
                  "Usuario creado exitosamente",
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  snackPosition: SnackPosition.BOTTOM,
                );

                // 🔹 Limpiar campos después de éxito
                _clearAllFields();

                // 🔹 Cambia a login solo si fue exitoso
                auth.isLogin.value = true;
              } catch (err) {
                Get.snackbar(
                  "Registro fallido",
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
  final TextInputType keyboardType;
  final bool obscureText;

  const _TextFieldGeneral({
    required this.labelText,
    required this.controller,
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
      ),
    );
  }
}
