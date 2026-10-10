import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../home_screen.dart';
import '../../services/demo_otp_service.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  String? verificationId;
  bool otpSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

 
Future<void> sendCode() async {
  final input = phoneController.text.trim();

  // Accept either 10 digits or +91 followed by 10 digits.
  final phone = input.replaceAll(RegExp(r'[\s-]'), '');
  final mobile = phone.startsWith('+91')
      ? phone.substring(3)
      : phone;

  if (!DemoOtpService.isEnabled) {
    final auth = context.read<AuthProvider>();

    if (!phone.startsWith('+91') ||
        !DemoOtpService.isValidIndianMobile(mobile)) {
      _showMessage('Enter a valid Indian number with +91');
      return;
    }

    await auth.sendPhoneCode(phone, (id) {
      if (!mounted) return;

      setState(() {
        verificationId = id;
        otpSent = true;
      });

      _showMessage('OTP sent successfully');
    });

    if (mounted && auth.error != null) {
      _showMessage(auth.error!);
    }
    return;
  }

  if (!DemoOtpService.isValidIndianMobile(mobile)) {
    _showMessage('Enter a valid 10-digit Indian mobile number');
    return;
  }

  setState(() {
    verificationId = 'DEMO';
    otpSent = true;
    otpController.clear();
  });

  _showMessage('Demo OTP: 123456 ');
}


 
Future<void> verifyCode() async {
  final otp = otpController.text.trim();
  final phone = phoneController.text.trim()
      .replaceAll(RegExp(r'[\s-]'), '');

  final mobile = phone.startsWith('+91')
      ? phone.substring(3)
      : phone;

  if (otp.isEmpty) {
    _showMessage('Please enter the OTP');
    return;
  }

  if (DemoOtpService.isEnabled) {
    final success = DemoOtpService.verifyOtp(
      phoneNumber: mobile,
      otp: otp,
    );

    if (!success) {
      _showMessage('Invalid OTP. Use 123456.');
      return;
    }

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ),
      (route) => false,
    );
    return;
  }

  if (verificationId == null ||
      verificationId == 'DEMO') {
    _showMessage('Please request an OTP first');
    return;
  }

  final auth = context.read<AuthProvider>();

  await auth.verifyPhoneCode(verificationId!, otp);

  if (!mounted) return;

  if (auth.error != null) {
    _showMessage(auth.error!);
    return;
  }

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const HomeScreen(),
    ),
    (route) => false,
  );
}


  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2A2A2A),
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 25, 24, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF303030),
                    ),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Center(
                child: Text(
                  'NewsNest',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              const Center(
                child: Text(
                  'Login securely using your phone number.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white54,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: const Color(0xFF303030),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Phone Number',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Include your country code, for example +91.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: !otpSent,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        labelStyle: const TextStyle(
                          color: Colors.white54,
                        ),
                        hintText: '+91 9876543210',
                        hintStyle: const TextStyle(
                          color: Colors.white38,
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_outlined,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF292929),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (otpSent) ...[
                      const SizedBox(height: 18),
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        style: const TextStyle(
                          color: Colors.white,
                          letterSpacing: 4,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          labelStyle: const TextStyle(
                            color: Colors.white54,
                          ),
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                            color: Colors.white54,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF292929),
                          counterText: '',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: auth.isLoading
                            ? null
                            : otpSent
                                ? verifyCode
                                : sendCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          disabledBackgroundColor:
                              const Color(0xFF444444),
                          disabledForegroundColor:
                              Colors.white54,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: auth.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : Text(
                                otpSent
                                    ? 'Verify OTP'
                                    : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                    if (otpSent) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              otpSent = false;
                              verificationId = null;
                              otpController.clear();
                            });
                          },
                          child: const Text(
                            'Change Phone Number',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}