import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/customButton.dart';
import '../../Widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({super.key});

  @override
  ConsumerState<ResetPassword> createState() => _ResetPassword();
}

class _ResetPassword extends ConsumerState<ResetPassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final bool _isLoading = false;

  /* Future<void> _forgotPassword(String email) async {
  setState(() => _isLoading = true);

  try {
    final response = await UserApi().forgotPassword(email: email);
    setState(() => _isLoading = false);
    if (mounted) {
      showSnackBar('Password reset OTP sent to your email.', ContentType.success);
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => const OTP(email: _emailController.text, isSignup: false),
        ),
        (Route<dynamic> route) => false,
      );
    }
  } catch (error) {
    showSnackBar(error.toString(), ContentType.failure);
    setState(() => _isLoading = false);
    throw Error(); 
  }
}*/

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        border: null,
      ),
      body: RoundedBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email*',
                        prefixIcon: const Icon(CupertinoIcons.mail),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty!";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email address!';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        isLoading: _isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            /* _forgotPassword(
                              _emailController.text,
                            ); */
                          }
                        },
                        text: 'Submit',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
