import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService authService = AuthService();

  User? user;
  bool isLoading = false;
  String? error;

  bool get isLoggedIn => user != null;

  AuthProvider() {
    authService.authStateChanges.listen((currentUser) {
      user = currentUser;
      notifyListeners();
    });
  }

  Future<bool> loginWithGoogle() async {
    try {
      setLoading(true);
      error = null;

      final result = await authService.signInWithGoogle();

      if (result == null) {
        error = 'Google Sign-In failed';
        return false;
      }

      user = result.user;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      debugPrint('Google Sign-In Error: $e');
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      setLoading(true);
      error = null;

      final result = await authService.loginWithEmail(
        email,
        password,
      );

      if (result == null) {
        error = 'Login failed';
        return false;
      }

      user = result.user;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> signupWithEmail(
    String email,
    String password,
  ) async {
    try {
      setLoading(true);
      error = null;

      final result = await authService.signUpWithEmail(
        email,
        password,
      );

      if (result == null) {
        error = 'Signup failed';
        return false;
      }

      user = result.user;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> sendPhoneCode(
    String phoneNumber,
    void Function(String verificationId) onCodeSent,
  ) async {
    try {
      setLoading(true);
      error = null;

      await authService.sendPhoneCode(
        phoneNumber: phoneNumber,
        codeSent: onCodeSent,
        verificationFailed: (firebaseError) {
          error = firebaseError.message;
          notifyListeners();
        },
      );

      return error == null;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<bool> verifyPhoneCode(
    String verificationId,
    String smsCode,
  ) async {
    try {
      setLoading(true);
      error = null;

      final result = await authService.verifyPhoneCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (result == null) {
        error = 'Phone verification failed';
        return false;
      }

      user = result.user;
      notifyListeners();

      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    await authService.logout();

    user = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}