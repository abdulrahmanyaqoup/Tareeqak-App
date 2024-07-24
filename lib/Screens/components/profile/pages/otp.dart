import 'package:dio/dio.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Screens/components/profile/pages/viewProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/api/otpApi.dart';

class Otp extends ConsumerStatefulWidget {
  final String email;
  const Otp({super.key, required this.email});

  @override
  _Otp createState() => _Otp();
}

class _Otp extends ConsumerState<Otp> {
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

    try {
      Map<String, dynamic> response =
          await OtpApi().verifyOTP(widget.email, otpController.text);
      String token = response['token'];
      User user = User.fromMap(response);
      ref.read(userProvider.notifier).signInVerfiedUser(user, token);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (_) => ViewProfile(
              onSignOut: () => (),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } on DioException catch (error) {
      setState(() {
        errorMessage = error.message;
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
                onPressed: () => verifyOtp(),
                child: const Text('Verify OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
