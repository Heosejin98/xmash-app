import 'package:get/get.dart';
import '../../ui/screens/home/main_screen.dart';
import '../../ui/screens/auth/login_screen.dart';

abstract class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String profile = '/profile';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
    )
  ];
} 