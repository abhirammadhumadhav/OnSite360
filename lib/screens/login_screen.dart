import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:media_hub/common/widgets/custom_text_field.dart';
import 'package:media_hub/controller/user/auth_controller.dart';
import 'package:media_hub/screens/forgot_password_screen.dart';
import 'package:media_hub/screens/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  final signInController = Get.put(AuthController());

  LoginScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/ca5869c081e69c7c77f1529df9e7e871.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: signInController.emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: signInController.passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.password_rounded,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  child: Text(
                    'Forgot Passowd?',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onTap: () {
                    Get.to(() => ForgotPasswordScreen());
                  },
                ),
                const SizedBox(height: 24),
                Column(
                  children: [
                    Obx(() {
                      return signInController.isLoading.value
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.black)),
                              onPressed: () {
                                Get.find<AuthController>().signIn();
                              },
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                    }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SignUpPage());
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
