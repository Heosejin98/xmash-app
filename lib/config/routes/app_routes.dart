import 'package:flutter/widgets.dart';
import '../../presentation/screens/home/main_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String profile = '/profile';
  
  static Map<String, WidgetBuilder> routes = {
    home: (context) => const MainScreen(),
    // profile: (context) => const ProfileScreen(),
  };
} 