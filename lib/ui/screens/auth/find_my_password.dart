import 'package:flutter/material.dart';

class FindMyPassword extends StatelessWidget {
  const FindMyPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: const Text(
        '비밀번호 찾기',
        style: TextStyle(
          fontSize: 12,
        ),
      ),
    );
  }
}