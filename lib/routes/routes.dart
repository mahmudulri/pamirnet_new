import 'package:get/get.dart';
import 'package:pamirnet/splash_screen.dart';

import '../bindings/basebinding.dart';
import '../bindings/sign_in_binding.dart';
import '../bindings/splash_binding.dart';
import '../screens/base_screen.dart';
import '../screens/sign_in_screen.dart';

const String splash = '/splash-screen';
const String signinscreen = '/sign-in-screen';
const String basescreen = '/base-screen';

List<GetPage> myroutes = [
  GetPage(name: splash, page: () => SplashScreen(), binding: SplashBinding()),
  GetPage(
    name: signinscreen,
    page: () => SignInScreen(),
    binding: SignInControllerBinding(),
  ),
  GetPage(
    name: basescreen,
    page: () => NewBaseScreen(),
    binding: Basebinding(),
  ),
];
