import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../api/userApi/userApi.dart';
import '../../provider/userProvider.dart';
import '../../screens/profile/loginScreen.dart';
import '../../widgets/customButton.dart';
import '../../widgets/snackBar.dart';
import 'profileScreen.dart';

@immutable
class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({required this.email, required this.isSignup, super.key});

  final String email;
  final bool isSignup;

  @override
  ConsumerState<VerifyScreen> createState() => _VerifyScreen();
}

class _VerifyScreen extends ConsumerState<VerifyScreen> {
  final UserApi _userApi = UserApi();
  String currentText = '';
  bool _isLoading = false;
  String? _errorMessage;

  String censuredEmail(String email) {
    const hiderPlaceholder = '****';
    return email.replaceRange(3, email.indexOf('@'), hiderPlaceholder);
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    await _userApi
        .verify(widget.email, currentText)
        .then(
          (response) async => {
            await _signInVerified(response),
            setState(() => _isLoading = false),
          },
        )
        .catchError(
      (Object error) {
        setState(() {
          _errorMessage = error.toString();
          _isLoading = false;
        });
        throw Error();
      },
    );
  }

  Future<void> _signInVerified(Map<String, dynamic> response) async {
    await ref
        .read(userProvider.notifier)
        .signInVerifiedUser(response)
        .then(
          (response) => {
            if (mounted)
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute<void>(
                  builder: (_) => const ProfileScreen(),
                ),
              ),
          },
        )
        .catchError(
      (Object error, stackTrace) {
        showSnackBar(error.toString(), ContentType.failure);
        throw Error();
      },
    );
  }

  Future<void> _resetPasswordVerify() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await _userApi
        .resetPasswordVerify(widget.email, currentText)
        .then(
          (response) => {
            if (mounted)
              Navigator.of(context).pushReplacement(
                CupertinoPageRoute<void>(
                  builder: (_) => const LoginScreen(),
                ),
              ),
            showSnackBar(
              'New password sent to your email.',
              ContentType.success,
            ),
          },
        )
        .catchError(
      (Object error) {
        showSnackBar(error.toString(), ContentType.failure);
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
        throw Error();
      },
    );
  }

  Future<void> _deleteUnverifiedUser() async {
    await _userApi.deleteUnverified(widget.email).catchError(
      (Object error) {
        showSnackBar(error.toString(), ContentType.failure);
        throw Error();
      },
    );
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
            if (widget.isSignup) _deleteUnverifiedUser(),
            Navigator.of(context).pop(),
          },
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                    'assets/animations/book.json',
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
                  onChanged: (String value) {
                    currentText = value;
                  },
                  useHapticFeedback: true,
                  pastedTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  appContext: context,
                  animationType: AnimationType.scale,
                  autovalidateMode: AutovalidateMode.onUnfocus,
                  length: 6,
                  keyboardType: TextInputType.number,
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
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed:
                      widget.isSignup ? _verifyOtp : _resetPasswordVerify,
                  text: 'Verify OTP',
                  width: 150,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
