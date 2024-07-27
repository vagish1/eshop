// ignore_for_file: use_build_context_synchronously

import 'package:eshop/authentication/controller/authentication_controller.dart';
import 'package:eshop/authentication/firebase/auth.dart';
import 'package:eshop/constants/app_const.dart';
import 'package:eshop/db/firebase_db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController emailAddress = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create a new account",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 24.h,
            ),
            TextFormField(
              controller: fullName,
              decoration: InputDecoration(
                filled: true,
                contentPadding: EdgeInsets.all(12.sp),
                label: const Text("Full Name"),
                border: const UnderlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: emailAddress,
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
            Consumer<AuthController>(builder: (context, auth, child) {
              return auth.isRegistering == true
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (fullName.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please provide full name");
                          return;
                        }
                        if (isValidEmail(emailAddress.text) == false) {
                          Fluttertoast.showToast(
                              msg: "Please provide valid email");
                          return;
                        }
                        if (password.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: "Please provide password");
                          return;
                        }

                        final User? user = await Authentication.instance
                            .createUser(
                                email: emailAddress.text,
                                password: password.text,
                                authController: auth);

                        if (user != null) {
                          final String? docId =
                              await FirebaseDb.instance.addUserToDb(body: {
                            "fullName": fullName.text,
                            "email": emailAddress.text,
                          });

                          auth.updateIsRegistering(isRegistering: false);
                          Navigator.pop(context);

                          debugPrint(docId);
                          Fluttertoast.showToast(
                              msg: "User Created Successfully");
                          return;
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50.h),
                      ),
                      child: Text(
                        "Signup",
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
                const Text("Already have account?"),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: const Text("Login"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
