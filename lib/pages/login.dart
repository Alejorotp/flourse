import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String id = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
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
                  onTap: () {
                    // Handle login tap
                  },
                  child: Text("Login"),
                ),
                GestureDetector(
                  onTap: () {
                    // Handle sign up tap
                  },
                  child: Text("Sign Up"),
                )
              ],
            ),
            SizedBox(height: 20),
            _textFieldEmail(),
            SizedBox(height: 8),
            _textFieldPassword(),
            SizedBox(height: 25),
            _buttonLogReg(),
          ],
        ),
      ),
    );
  }

  Widget _textFieldEmail() {
    return _TextFieldGeneral(
      labelText: "Email",
      onChanged: (value) {
        // Handle email change
      },
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _textFieldPassword() {
    return _TextFieldGeneral(
      labelText: "Password",
      onChanged: (value) {
        // Handle password change
      },
      obscureText: true,
    );
  }

  Widget _buttonLogReg() {
    return ElevatedButton(
      onPressed: () {
        // Handle login or registration button press
      },
      child: Text("Login"), 
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
