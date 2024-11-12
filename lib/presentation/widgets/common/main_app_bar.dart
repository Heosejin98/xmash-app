import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  void _handleProfileTap() {
    final authController = Get.find<AuthController>();
    
    if (authController.checkLoginStatus()) {
      // 로그인된 경우 프로필 페이지로 이동
      // Get.toNamed('/profile');
      Get.toNamed('/login');
    } else {
      // 로그인되지 않은 경우 로그인 페이지로 이동
      Get.toNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Xmash'),
      actions: [
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: _handleProfileTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 