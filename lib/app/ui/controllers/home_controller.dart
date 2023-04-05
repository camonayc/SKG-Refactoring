import 'package:get/get.dart';
import 'package:skg_refactoring/app/routes/routes.dart';

class HomeController extends GetxController {
  static HomeController initializeController() {
    try {
      HomeController controller = Get.find<HomeController>();
      return controller;
    } catch (e) {
      HomeController controller = Get.put(HomeController());
      return controller;
    }
  }

  RxBool isLoading = false.obs;

  Future<void> goToRegisterPage() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    Get.toNamed(AppRoutes.REGISTER);
    isLoading.value = false;
  }
  Future<void> goToRegisterPageFromDrawer() async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 3));
    isLoading.value = false;
  }
}
