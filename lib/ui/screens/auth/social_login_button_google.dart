import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButtonGoogle extends StatelessWidget {
  const SocialLoginButtonGoogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 216, 216, 216)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.white,
          fixedSize: const Size(60, 60),
        ),
        icon: SvgPicture.asset(
          'assets/icons/google.svg',
          width: 30,
          height: 30,
        ),
        onPressed: () {},
      ),
    );
  }
}