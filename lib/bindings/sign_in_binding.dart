import 'package:get/get.dart';
import 'package:pamirnet/controllers/sign_in_controller.dart';

class SignInControllerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignInController>(() => SignInController());
  }
}
