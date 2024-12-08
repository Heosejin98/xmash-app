import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:xmash_app/ui/screens/auth/auth_title.dart';
import 'package:xmash_app/ui/screens/auth/input_email.dart';
import 'package:xmash_app/ui/screens/auth/input_password.dart';
import 'package:xmash_app/ui/controllers/auth_controller.dart';
import 'package:xmash_app/ui/screens/auth/login_state_checkbox.dart';
import 'package:xmash_app/ui/screens/auth/find_my_password.dart';
import 'package:xmash_app/ui/screens/auth/email_login_button.dart';
import 'package:xmash_app/ui/screens/auth/or_divider.dart';
import 'package:xmash_app/ui/screens/auth/signup_section.dart';
import 'package:xmash_app/ui/screens/auth/social_login_button_section.dart';

class LoginScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AuthTitle(),
            InputEmail(controller: _usernameController),
            const SizedBox(height: 24),
            InputPassword(controller: _passwordController),
            const SizedBox(height: 12),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LoginStateCheckbox(),
                FindMyPassword(),
              ],
            ),
            const SizedBox(height: 24),
            EmailLoginButton(
              authController: _authController,
              usernameController: _usernameController,
              passwordController: _passwordController,
            ),
            const SizedBox(height: 24),
            const OrDivider(),
            const SizedBox(height: 24),
            const SocialLoginButtonSection(),
            const SizedBox(height: 24),
            const SignUpSection(),
          ],
        ),
      ),
    );
  }
}
