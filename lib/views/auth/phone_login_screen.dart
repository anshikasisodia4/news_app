import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../home_screen.dart';

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
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      _showMessage('Please enter your phone number');
      return;
    }

    final auth = context.read<AuthProvider>();

    await auth.sendPhoneCode(
      phone,
      (id) {
        if (!mounted) return;

        setState(() {
          verificationId = id;
          otpSent = true;
        });

        _showMessage('OTP sent successfully');
      },
    );

    if (!mounted) return;

    if (auth.error != null) {
      _showMessage(auth.error!);
    }
  }

  Future<void> verifyCode() async {
    final otp = otpController.text.trim();

    if (verificationId == null) {
      _showMessage('Please request an OTP first');
      return;
    }

    if (otp.isEmpty) {
      _showMessage('Please enter the OTP');
      return;
    }

    final auth = context.read<AuthProvider>();

    await auth.verifyPhoneCode(
      verificationId!,
      otp,
    );

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
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F0),
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
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(23),
                  ),
                  child: const Icon(
                    Icons.phone_android_rounded,
                    color: Colors.white,
                    size: 38,
                  ),
                ),
              ),
              const SizedBox(height: 22),
              const Center(
                child: Text(
                  'Phone Login',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF20251F),
                  ),
                ),
              ),
              const SizedBox(height: 7),
              const Center(
                child: Text(
                  'Login securely using your phone number.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF737A71),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Enter Phone Number',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF20251F),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Include your country code, for example +91.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF737A71),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      enabled: !otpSent,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: '+91 9876543210',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        filled: true,
                        fillColor: const Color(0xFFF2F5F0),
                        border: OutlineInputBorder(
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
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          prefixIcon: const Icon(Icons.password_outlined),
                          filled: true,
                          fillColor: const Color(0xFFF2F5F0),
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
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
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
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                otpSent ? 'Verify OTP' : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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
                              color: Color(0xFF20251F),
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