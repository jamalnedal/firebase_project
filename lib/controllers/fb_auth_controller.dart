import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vp9_firebase/helpers/helpers.dart';

typedef UserStateCallback = void Function(bool status);

class FbAuthController with Helpers {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> createAccount(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        showSnackBar(
            context: context,
            message: 'Account created successfully, verify your email');
        await userCredential.user!.sendEmailVerification();
        await signOut();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      _controlAuthException(context, exception: e);
    } catch (e) {
      //
    }
    return false;
  }

  Future<bool> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        if (userCredential.user!.emailVerified) {
          return true;
        }

        showSnackBar(
            context: context,
            message: 'Login rejected, verify your email!',
            error: true);
        await userCredential.user!.sendEmailVerification();
        await signOut();
      }
      return false;
    } on FirebaseAuthException catch (e) {
      _controlAuthException(context, exception: e);
    } catch (e) {
      //
    }
    return false;
  }

  Future<bool> forgetPassword(BuildContext context,
      {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      _controlAuthException(context, exception: e);
    } catch (e) {
      //
    }
    return false;
  }

  void _controlAuthException(BuildContext context,
      {required FirebaseAuthException exception}) {
    showSnackBar(
        context: context, message: exception.message ?? '', error: true);
    if (exception.code == 'email-already-in-use') {
    } else if (exception.code == 'invalid-email') {
    } else if (exception.code == 'operation-not-allowed') {
    } else if (exception.code == 'weak-password') {
    } else if (exception.code == 'user-disabled') {
    } else if (exception.code == 'user-not-found') {
    } else if (exception.code == 'wrong-password') {}
  }

  // bool get loggedIn => _firebaseAuth.currentUser != null;

  StreamSubscription listenToUserState(
      {required UserStateCallback userStateCallback}) {
    return _firebaseAuth.authStateChanges().listen((user) {
      userStateCallback(user != null);
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
