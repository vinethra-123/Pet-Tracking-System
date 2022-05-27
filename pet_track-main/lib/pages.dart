import 'package:get/get.dart';
import 'package:pet_track/pages/auth/auth_page.dart';
import 'package:pet_track/pages/home/home_page.dart';
import 'package:pet_track/pages/splash/splash_page.dart';

class Pages {
  static String home = "/home";
  static String auth = "/auth";
  static String splash = "/splash";

  static List<GetPage> all = [
    GetPage(name: home, page: () => const HomePage()),
    GetPage(name: auth, page: () => const AuthPage()),
    GetPage(name: splash, page: () => const SplashPage()),
  ];
}
