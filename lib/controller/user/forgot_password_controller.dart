import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void ResetPassword() {
    FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    Get.snackbar(
      'Password Reset',
      'A password reset link has been sent to your email.',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade800,
      snackPosition: SnackPosition.TOP,
    );
  }
}
