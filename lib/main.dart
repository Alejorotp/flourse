import 'package:flourse/pages/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //theme: ThemeData('data'),
      initialRoute: LoginPage.id,
      routes: {LoginPage.id: (_) => const LoginPage()},
    );
  }
}
