import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialLoginButtonKakao extends StatelessWidget {
  const SocialLoginButtonKakao({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Colors.yellow,
        fixedSize: const Size(60, 60),
      ),
      icon: SvgPicture.asset(
        'assets/icons/kakao.svg',
        width: 30,
        height: 30,
      ),
      onPressed: () {},
    );
  }
}