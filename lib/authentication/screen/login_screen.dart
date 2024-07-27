import 'package:eshop/authentication/controller/authentication_controller.dart';
import 'package:eshop/authentication/firebase/auth.dart';
import 'package:eshop/constants/app_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          width: double.infinity,
          height: 350.h,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                "https://images.unsplash.com/photo-1500068939895-dd5d4be36e7e?q=80&w=2970&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(
                height: 24.h,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.all(12.sp),
                  label: const Text("Email Address"),
                  border: const UnderlineInputBorder(),
                  prefixIcon: const Icon(Icons.mail),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              TextFormField(
                obscureText: true,
                controller: password,
                decoration: InputDecoration(
                  filled: true,
                  contentPadding: EdgeInsets.all(12.sp),
                  label: const Text("Password"),
                  border: const UnderlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Consumer<AuthController>(builder: (context, controller, child) {
                return controller.isLogingIn == true
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (isValidEmail(email.text) == false) {
                            Fluttertoast.showToast(
                                msg: "Please provide a valid email");
                            return;
                          }
                          if (password.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please provide a valid password");
                            return;
                          }
                          controller.updateIsLogginIn(isLogingIn: true);

                          final User? user = await Authentication.instance
                              .loginWithEmailAndPassword(
                                  email: email.text, password: password.text);

                          controller.updateIsLogginIn(isLogingIn: false);

                          if (user != null) {
                            Fluttertoast.showToast(
                                msg: "Loging In successfull");
                            return;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50.h),
                        ),
                        child: Text(
                          "Login",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.white),
                        ),
                      );
              }),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New Here ?"),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/signup");
                      },
                      child: const Text("Signup"))
                ],
              )
            ],
          ),
        )
      ],
    ));
  }
}
