import 'package:dio/dio.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/profile/profileScreen.dart';
import 'package:finalproject/api/otpApi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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

  String censuredEmail(String email) {
    const hiderPlaceholder = '****';
    return email.replaceRange(3, email.indexOf("@"), hiderPlaceholder);
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
      ref.read(userProvider.notifier).signInVerifiedUser(user, token);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(
            builder: (_) => const ProfileScreen(),
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
        title: const Text('Verify OTP'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              Container(
                height: 200,
                width: 400,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Lottie.asset(
                  'assets/animations/logo.json',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Enter Verification Code',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Please verifiy the OTP that has been sent to this Email ${censuredEmail(widget.email)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 40.0),
              PinCodeTextField(
                controller: otpController,
                appContext: context,
                length: 6,
                keyboardType: TextInputType.number,
                onChanged: (value) {},
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(8),
                  inActiveBoxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 1.0,
                      spreadRadius: .1,
                    )
                  ],
                  fieldHeight: 50,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.grey.shade200,
                  selectedFillColor: Colors.white,
                  activeColor: Colors.transparent,
                  inactiveColor: Colors.grey.shade200,
                  selectedColor: Theme.of(context).colorScheme.primary,
                ),
                enableActiveFill: true,
              ),
              const SizedBox(height: 20.0),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () => verifyOtp(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 40),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Verify OTP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        )),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
