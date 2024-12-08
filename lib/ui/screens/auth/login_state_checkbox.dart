import 'package:flutter/material.dart';

class LoginStateCheckbox extends StatelessWidget {
  const LoginStateCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          activeColor: Colors.blue,
          side: const BorderSide(color: Color.fromARGB(255, 161, 161, 161)),
          onChanged: (value) {},
        ),
        const Text(
          '로그인 상태 유지',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}