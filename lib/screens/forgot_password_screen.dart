import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_hub/common/widgets/custom_text_field.dart';
import 'package:media_hub/controller/user/forgot_password_controller.dart';
import 'package:media_hub/screens/login_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final forgotPasswordController = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Forgot Password',style: TextStyle(fontWeight: FontWeight.bold),),),
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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(), // or Navigator.pop(context)
                  ),
                  Text(
                    'Reset Password',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Receive an email to\nreset your Passowrd.',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 24,
                ),
                CustomTextField(
                  controller: forgotPasswordController.emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      forgotPasswordController.ResetPassword();

                      Get.to(() => LoginScreen());
                    },
                    child: Text(
                      'Reset Password',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
