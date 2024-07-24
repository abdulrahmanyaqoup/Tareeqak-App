import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/api/otpApi.dart';

class OTPScreen extends ConsumerStatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends ConsumerState<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  Future<void> verifyOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final user = ref.read(userProvider).user;

    try {
      final response = await OtpApi().verifyOTP(user.email, otpController.text);

      print(response);
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to verify OTP. Please try again.';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PinCodeTextField(
                controller: otpController,
                appContext: context,
                length: 6,
                onChanged: (value) {},
                onCompleted: (value) {},
              ),
              const SizedBox(height: 20.0),
              if (isLoading) const CircularProgressIndicator(),
              if (errorMessage != null)
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: isLoading ? null : verifyOtp,
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
