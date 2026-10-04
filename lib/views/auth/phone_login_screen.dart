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
  bool codeSent = false;

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  Future<void> sendCode() async {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter your phone number'),
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.sendPhoneCode(
      phone,
      (id) {
        setState(() {
          verificationId = id;
          codeSent = true;
        });
      },
    );

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ?? 'Failed to send OTP',
          ),
        ),
      );
    }
  }

  Future<void> verifyCode() async {
    if (verificationId == null) {
      return;
    }

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.verifyPhoneCode(
      verificationId!,
      otpController.text.trim(),
    );

    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authProvider.error ?? 'Invalid OTP',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phone Login'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.phone_android,
                size: 70,
              ),
              const SizedBox(height: 20),
              const Text(
                'Login with Phone',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '+91XXXXXXXXXX',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              if (codeSent)
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'OTP',
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : codeSent
                          ? verifyCode
                          : sendCode,
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                          codeSent ? 'Verify OTP' : 'Send OTP',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}