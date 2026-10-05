import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> initializeGoogleSignIn() async {
    await _authService.initializeGoogleSignIn();
  }

  Future<bool> loginWithGoogle() async {
    try {
      _setLoading(true);
      _error = null;

      await _authService.signInWithGoogle();

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);
      _error = null;

      await _authService.loginWithEmail(
        email,
        password,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signupWithEmail(
    String email,
    String password,
  ) async {
    try {
      _setLoading(true);
      _error = null;

      await _authService.signUpWithEmail(
        email,
        password,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> sendPhoneCode(
    String phoneNumber,
    void Function(String verificationId) onCodeSent,
  ) async {
    try {
      _setLoading(true);
      _error = null;

      await _authService.sendPhoneCode(
        phoneNumber: phoneNumber,
        codeSent: onCodeSent,
        verificationFailed: (error) {
          _error = error.message ?? 'Phone verification failed';
          notifyListeners();
        },
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyPhoneCode(
    String verificationId,
    String smsCode,
  ) async {
    try {
      _setLoading(true);
      _error = null;

      await _authService.verifyPhoneCode(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
      _user = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}