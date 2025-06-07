import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/common/widgets/custom_text_field.dart';
import 'package:media_hub/controller/user/auth_controller.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({
    super.key,
  });

  final signUpController = Get.put(AuthController());

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
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(), // or Navigator.pop(context)
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextField(
                    controller: signUpController.emailController,
                    labelText: 'Email',
                    prefixIcon: Icons.email_outlined),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: signUpController.passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.password_outlined,
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                Obx(() {
                  return signUpController.isLoading.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.black)),
                          onPressed: () => signUpController.signUp(),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
