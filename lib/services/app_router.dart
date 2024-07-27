import 'package:eshop/authentication/controller/authentication_controller.dart';
import 'package:eshop/authentication/screen/login_screen.dart';
import 'package:eshop/authentication/screen/signup_screen.dart';
import 'package:eshop/product/controller/product_controller.dart';
import 'package:eshop/screen/home_page.dart';
import 'package:eshop/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';

  static const String feed = '/home';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case feed:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (BuildContext context) {
                  return ProductController();
                },
                child: const HomePage()));
      case login:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (BuildContext context) {
                  return AuthController();
                },
                child: const LoginScreen()));
      case signup:
        return MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (BuildContext context) {
                  return AuthController();
                },
                child: const SignupScreen()));
      default:
        return MaterialPageRoute(builder: (_) => const NotFound());
    }
  }
}

class NotFound extends StatefulWidget {
  const NotFound({super.key});

  @override
  State<NotFound> createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
