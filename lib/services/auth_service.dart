import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _googleInitialized = false;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> initializeGoogleSignIn() async {
    if (_googleInitialized) return;

    await _googleSignIn.initialize(
      serverClientId:
          '92863232638-n4n8c36d4u40emm5e3gr3a6v2o1ms6b7.apps.googleusercontent.com',
    );

    _googleInitialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      await initializeGoogleSignIn();

      final googleUser = await _googleSignIn.authenticate();

      final googleAuth = googleUser.authentication;

      if (googleAuth.idToken == null) {
        throw Exception('Google ID token is null');
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      debugPrint('Google Sign-In Error: $e');
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email Signup Error: ${e.code}');
      debugPrint('Email Signup Message: ${e.message}');
      rethrow;
    }
  }

  Future<UserCredential> loginWithEmail(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('Email Login Error: ${e.code}');
      debugPrint('Email Login Message: ${e.message}');
      rethrow;
    }
  }

  Future<void> sendPhoneCode({
    required String phoneNumber,
    required void Function(String verificationId) codeSent,
    required void Function(FirebaseAuthException error)
        verificationFailed,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);
            debugPrint(
              'Phone verification completed automatically',
            );
          } on FirebaseAuthException catch (e) {
            debugPrint(
              'Automatic phone verification error: ${e.code}',
            );
            debugPrint(
              'Automatic phone verification message: ${e.message}',
            );
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          debugPrint(
            'PHONE AUTH ERROR CODE: ${error.code}',
          );
          debugPrint(
            'PHONE AUTH ERROR MESSAGE: ${error.message}',
          );

          verificationFailed(error);
        },
        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          debugPrint('OTP SENT SUCCESSFULLY');
          debugPrint('Verification ID received');

          codeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (
          String verificationId,
        ) {
          debugPrint('OTP auto retrieval timeout');
        },
      );
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'Phone authentication exception: ${e.code}',
      );
      debugPrint(
        'Phone authentication message: ${e.message}',
      );

      verificationFailed(e);
    } catch (e) {
      debugPrint('Phone authentication error: $e');

      verificationFailed(
        FirebaseAuthException(
          code: 'unknown-error',
          message: e.toString(),
        ),
      );
    }
  }

  Future<UserCredential> verifyPhoneCode({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint(
        'OTP VERIFICATION ERROR CODE: ${e.code}',
      );
      debugPrint(
        'OTP VERIFICATION ERROR MESSAGE: ${e.message}',
      );
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Google Sign-Out Error: $e');
    }

    await _auth.signOut();
  }
}