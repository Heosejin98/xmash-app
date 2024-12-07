import 'package:flutter/material.dart';

class SignUpSection extends StatelessWidget {
  const SignUpSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          '아직 회원이 아니신가요?',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            '회원가입',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}
