import 'package:eshop/authentication/controller/authentication_controller.dart';
import 'package:eshop/authentication/screen/login_screen.dart';
import 'package:eshop/config/theme/app_theme.dart';
import 'package:eshop/firebase_options.dart';
import 'package:eshop/product/controller/product_controller.dart';
import 'package:eshop/screen/home_page.dart';
import 'package:eshop/screen/splash_screen.dart';
import 'package:eshop/services/app_router.dart';
import 'package:eshop/services/remote_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaeRemote.instance.initialize();

  runApp(const EshopApp());
}

class EshopApp extends StatelessWidget {
  const EshopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      builder: (context, child) {
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: SplashScreen(),
              );
            }

            return MultiProvider(
              providers: [
                ChangeNotifierProvider(
                  create: (context) => AuthController(),
                ),
                if (snapshot.hasData)
                  ChangeNotifierProvider(
                    create: (context) => ProductController(),
                  ),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: AppThemeData.instance.getLightThemeData(),
                home: snapshot.hasData ? const HomePage() : const LoginScreen(),
                onGenerateRoute: AppRouter.generateRoute,
              ),
            );
          },
        );
      },
    );
  }
}
