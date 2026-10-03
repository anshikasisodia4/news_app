import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';

class AuthController {
  final AuthProvider authProvider;

  AuthController(this.authProvider);

  Future<bool> loginWithEmail(
    String email,
    String password,
  ) async {
    return await authProvider.loginWithEmail(
      email,
      password,
    );
  }

  Future<bool> signupWithEmail(
    String email,
    String password,
  ) async {
    return await authProvider.signupWithEmail(
      email,
      password,
    );
  }

  Future<bool> loginWithGoogle() async {
    return await authProvider.loginWithGoogle();
  }

  Future<bool> sendPhoneCode(
    String phoneNumber,
    void Function(String verificationId) onCodeSent,
  ) async {
    return await authProvider.sendPhoneCode(
      phoneNumber,
      onCodeSent,
    );
  }

  Future<bool> verifyPhoneCode(
    String verificationId,
    String smsCode,
  ) async {
    return await authProvider.verifyPhoneCode(
      verificationId,
      smsCode,
    );
  }

  Future<void> logout() async {
    await authProvider.logout();
  }

  String? get error => authProvider.error;

  bool get isLoading => authProvider.isLoading;

  bool get isLoggedIn => authProvider.isLoggedIn;

  void showError(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}