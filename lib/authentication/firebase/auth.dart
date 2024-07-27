import 'package:eshop/authentication/controller/authentication_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Authentication {
  Authentication.init();
  static Authentication instance = Authentication.init();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final UserCredential credential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (err) {
      debugPrint(err.message);
      debugPrint(err.code);

      if (err.code == "user-not-found") {
        Fluttertoast.showToast(
            msg: "User doesn't exists with the provided email");
        return null;
      }
      if (err.code == "invalid-email") {
        Fluttertoast.showToast(msg: "Provided email is invalid");
        return null;
      }
      if (err.code == "invalid-credential") {
        Fluttertoast.showToast(
            msg: "invalid credentials or account doesn't exits");
        return null;
      }
      if (err.code == "wrong-password") {
        Fluttertoast.showToast(msg: "Password incorrect");
        return null;
      }
      if (err.code == "user-disabled") {
        Fluttertoast.showToast(msg: "Your account has been disabled");
        return null;
      }
    }
    return null;
  }

  Future<User?> createUser(
      {required String email,
      required String password,
      required AuthController authController}) async {
    try {
      authController.updateIsRegistering(isRegistering: true);
      final UserCredential credential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (err) {
      authController.updateIsRegistering(isRegistering: false);

      if (err.code == "email-already-in-use") {
        Fluttertoast.showToast(
            msg: "User already exists with the provided email");
        return null;
      }
      if (err.code == "invalid-email") {
        Fluttertoast.showToast(msg: "Provided email is invalid");
        return null;
      }
      if (err.code == "weak-password") {
        Fluttertoast.showToast(msg: "Password is weak");
        return null;
      }
    }
    return null;
  }
}
