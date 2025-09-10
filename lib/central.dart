import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flourse/features/home/ui/pages/home.dart';
import 'package:flourse/features/auth/ui/pages/login.dart';
import 'package:flourse/features/auth/ui/controller/auth_controller.dart';

class Central extends StatelessWidget {
  const Central({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationController authenticationController = Get.find();
    return Obx(
      () => authenticationController.isLogged 
      ? const HomePage() 
      : LoginPage(),
    );
  }
}
