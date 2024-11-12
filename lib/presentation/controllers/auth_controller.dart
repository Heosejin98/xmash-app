import 'package:get/get.dart';
import 'package:xmash_app/data/services/auth_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final AuthService _authService = AuthService();
  final error = Rxn<String>();
  final isLoggedIn = false.obs;

   Future<void> login(String userId, String password) async {
    try {
      final response = await _authService.login(userId, password);

      if (response.statusCode == 200) {
        // 성공적으로 로그인한 경우 홈 화면으로 이동
        isLoggedIn.value = true;
        Get.offNamed('/home');
      } else {
        // 로그인 실패한 경우 처리
        Get.snackbar('Error', '로그인 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      Get.snackbar('Error', '로그인 중 오류 발생: $e');
    }
  }

  bool checkLoginStatus() {
    return isLoggedIn.value;
  }
} 