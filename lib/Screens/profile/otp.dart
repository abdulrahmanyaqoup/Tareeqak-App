import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../api/otpApi.dart';
import '../../model/User/user.dart';
import '../../provider/userProvider.dart';
import '../../widgets/customButton.dart';
import '../../widgets/snackBar.dart';
import 'profile.dart';

class Otp extends ConsumerStatefulWidget {
  const Otp({required this.email, super.key});

  final String email;

  @override
  ConsumerState<Otp> createState() => _Otp();
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
    return email.replaceRange(3, email.indexOf('@'), hiderPlaceholder);
  }

  Future<void> _verifyOtp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    var token = '';
    var user = const User();

    await OtpApi()
        .verifyOTP(widget.email, otpController.text)
        .then((response) async {
      token = response['token'] as String;
      user = User.fromMap(response);
      await _signInVerified(user, token);
      setState(() {
        isLoading = false;
      });
    }).catchError(
      (Object error) {
        setState(() {
          errorMessage = error.toString();
          isLoading = false;
        });
        throw Error();
      },
    );
  }

  Future<void> _signInVerified(User user, String token) async {
    await ref
        .read(userProvider.notifier)
        .signInVerifiedUser(user, token)
        .then(
          (response) => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute<void>(
              builder: (_) => const Profile(),
            ),
            (Route<dynamic> route) => false,
          ),
        )
        .catchError(
          (Object error, stackTrace) => {
            showSnackBar(context, error.toString(), ContentType.failure),
            throw Error(),
          },
        );
  }

  Future<void> _deleteUnverifiedUser() async {
    try {
      await OtpApi().deleteUnverified(widget.email);
    } on DioException catch (error) {
      if (!mounted) return;
      showSnackBar(context, error.toString(), ContentType.failure);
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
          onPressed: () => {
            _deleteUnverifiedUser(),
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Text(
                'Enter Verification Code',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Please verifiy the OTP that has been sent to this Email '
                '${censuredEmail(widget.email)}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 40),
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
                      blurRadius: 1,
                      spreadRadius: .1,
                    ),
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
              const SizedBox(height: 20),
              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              CustomButton(
                onPressed: _verifyOtp,
                text: 'Verify OTP',
                width: 150,
                isLoading: isLoading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
