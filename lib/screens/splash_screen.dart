import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/common/widgets/bottom_navigation_bar.dart';
import 'package:media_hub/controller/user/auth_controller.dart';
import 'package:media_hub/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    // Trigger navigation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        Get.offAll(() =>
            authController.isLoggedIn ? MainNavigationScreen() : LoginScreen());
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/images/drone_7237232.png', height: 150),
            const Text(
              '𝓞𝓷𝓢𝓲𝓽𝓮360',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
