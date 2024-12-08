import 'package:flutter/material.dart';
import 'package:xmash_app/ui/controllers/auth_controller.dart';

class EmailLoginButton extends StatelessWidget {
  const EmailLoginButton({
    super.key,
    required AuthController authController,
    required TextEditingController usernameController,
    required TextEditingController passwordController,
  }) : _authController = authController, _usernameController = usernameController, _passwordController = passwordController;

  final AuthController _authController;
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          _authController.login(_usernameController.text, _passwordController.text); // 로그인 로직 호출
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          '이메일로 시작하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}