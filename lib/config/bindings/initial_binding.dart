import 'package:get/get.dart';
import 'package:xmash_app/ui/controllers/auth_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
} 