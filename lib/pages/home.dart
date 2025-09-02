import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flourse/controllers/auth_controller.dart';

class HomePage extends StatelessWidget {
  static const String id = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return PopScope(
      canPop: false, // evita salir con back del SO directamente
      onPopInvoked: (didPop) {
        if (!didPop) {
          auth.logout();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              auth.logout();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                auth.logout();
              },
            ),
          ],
        ),
        body: Center(
          child: Obx(() => Text(
                "Bienvenido, ${auth.userName.value.isEmpty ? 'Usuario' : auth.userName.value} 🎉",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
      ),
    );
  }
}
