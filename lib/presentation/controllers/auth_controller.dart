import 'package:get/get.dart';

class AuthController extends GetxController {
   static AuthController get to => Get.find();
  final error = Rxn<String>();
  final isLoggedIn = false.obs;

  Future<void> login(String username, String password) async {
    try {
      isLoggedIn.value = true;
      error.value = null;
      
      await Future.delayed(const Duration(seconds: 1)); // 임시 딜레이
      
      // 로그인 성공 시 홈 화면으로 이동
      Get.offAllNamed('/');
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoggedIn.value = false;
    }
  }

  bool checkLoginStatus() {
    return isLoggedIn.value;
  }
} 