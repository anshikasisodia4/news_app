import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get error => _error;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      _isInitialized = true;
      notifyListeners();
    });
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email.trim());
  }

  String _getFriendlyError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'email-already-in-use':
          return 'An account with this email already exists.';
        case 'weak-password':
          return 'Please choose a stronger password.';
        case 'too-many-requests':
          return 'Too many attempts. Please try again later.';
        case 'network-request-failed':
          return 'Please check your internet connection.';
        case 'user-disabled':
          return 'This account has been disabled.';
        case 'invalid-verification-code':
          return 'Incorrect OTP. Please try again.';
        case 'session-expired':
          return 'Your OTP has expired. Please request a new one.';
        default:
          return 'Something went wrong. Please try again.';
      }
    }

    return 'Something went wrong. Please try again.';
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
      _error = _getFriendlyError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithEmail(
    String email,
    String password,
  ) async {
    final cleanEmail = email.trim();

    if (!_isValidEmail(cleanEmail)) {
      _error = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    try {
      _setLoading(true);
      _error = null;

      await _authService.loginWithEmail(cleanEmail, password);
      return true;
    } catch (e) {
      _error = _getFriendlyError(e);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signupWithEmail(
    String email,
    String password,
  ) async {
    final cleanEmail = email.trim();

    if (!_isValidEmail(cleanEmail)) {
      _error = 'Please enter a valid email address.';
      notifyListeners();
      return false;
    }

    try {
      _setLoading(true);
      _error = null;

      await _authService.signUpWithEmail(cleanEmail, password);
      return true;
    } catch (e) {
      _error = _getFriendlyError(e);
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
          _error = _getFriendlyError(error);
          notifyListeners();
        },
      );

      return true;
    } catch (e) {
      _error = _getFriendlyError(e);
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
      _error = _getFriendlyError(e);
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
      _error = _getFriendlyError(e);
      notifyListeners();
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}