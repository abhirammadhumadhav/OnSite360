import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:media_hub/common/authentication/auth.dart';
import 'package:media_hub/common/widgets/bottom_navigation_bar.dart';
import 'package:media_hub/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final Auth _auth = Auth();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var isLoading = false.obs;
  var firebaseUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges);
  }

  bool get isLoggedIn => firebaseUser.value != null;

  void signIn() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Missing Fields',
        'Please enter both email and password.',
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _auth.signInWithEmailandPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      if (uid == null) throw Exception("Invalid user UID");

      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (!doc.exists) {
        throw Exception("User data not found.");
      }

      Get.offAll(() => MainNavigationScreen());
    } catch (e) {
      final message = _getFriendlyErrorMessage(e.toString());
      Get.snackbar(
        'Login Failed',
        message,
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Missing Fields',
        'Please enter both email and password.',
        colorText: Get.theme.colorScheme.error,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;

      final userCredential = await _auth.createUserWithEmailandPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      final appUser = {
        'uid': uid,
        'email': email,
        'createdAt': DateTime.now(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set(appUser);

      Get.snackbar(
        'Success',
        'Account created successfully.',
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade800,
        snackPosition: SnackPosition.TOP,
      );

      Get.offAll(() => MainNavigationScreen());
    } catch (e) {
      final message = _getFriendlySignupErrorMessage(e.toString());
      Get.snackbar(
        'Sign Up Failed',
        message,
        colorText: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      emailController.clear();
      passwordController.clear();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Logout Failed',
        'Something went wrong while logging out.',
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  String _getFriendlyErrorMessage(String error) {
    if (error.contains('user-not-found')) {
      return 'No account found with this email.';
    } else if (error.contains('wrong-password')) {
      return 'Incorrect password. Please try again.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Check your internet connection.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }

  String _getFriendlySignupErrorMessage(String error) {
    if (error.contains('email-already-in-use')) {
      return 'This email is already registered. Try signing in instead.';
    } else if (error.contains('invalid-email')) {
      return 'The email address is not valid.';
    } else if (error.contains('weak-password')) {
      return 'Password is too weak. Please choose a stronger password.';
    } else if (error.contains('network-request-failed')) {
      return 'Network error. Check your internet connection.';
    } else {
      return 'Something went wrong. Please try again later.';
    }
  }
}


