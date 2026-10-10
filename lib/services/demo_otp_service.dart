
import 'package:flutter/foundation.dart';

class DemoOtpService {
  static const String _demoOtp = '123456';

  static bool get isEnabled => kDebugMode;

  static bool isValidIndianMobile(String phoneNumber) {
    return RegExp(r'^[6-9][0-9]{9}$')
        .hasMatch(phoneNumber);
  }

  static bool verifyOtp({
    required String phoneNumber,
    required String otp,
  }) {
    if (!isEnabled) return false;

    if (!isValidIndianMobile(phoneNumber)) {
      return false;
    }

    return otp == _demoOtp;
  }
}
