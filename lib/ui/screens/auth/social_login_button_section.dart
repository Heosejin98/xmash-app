import 'package:flutter/material.dart';
import 'package:xmash_app/ui/screens/auth/social_login_button_google.dart';
import 'package:xmash_app/ui/screens/auth/social_login_button_kakao.dart';
class SocialLoginButtonSection extends StatelessWidget {
  const SocialLoginButtonSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButtonGoogle(),
        SizedBox(width: 10),
        SocialLoginButtonKakao(),
      ],
    );
  }
}