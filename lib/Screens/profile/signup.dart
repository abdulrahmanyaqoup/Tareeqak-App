import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/customButton.dart';
import '../../Widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'profileScreen.dart';
import 'signin.dart';
import 'signupDetails.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => SignupScreenState();
}

class SignupScreenState extends ConsumerState<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void goToOptionalSignup() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        CupertinoPageRoute<void>(
          builder: (context) => SignupDetails(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
          ),
        ),
      );
    }
  }

  void profileScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => const ProfileScreen(),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Signup',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: nameController,
                        hintText: 'Enter your name*',
                        prefixIcon: const Icon(CupertinoIcons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name can't be empty!";
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: emailController,
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
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Enter your password*',
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password can't be empty!";
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters!';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: confirmPasswordController,
                        hintText: 'Confirm your password*',
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirm Password can't be empty!";
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match!';
                          }
                          return null;
                        },
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        textColor: Colors.white,
                        onPressed: goToOptionalSignup,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 45,
                          vertical: 10,
                        ),
                        text: 'Next',
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          CupertinoPageRoute<void>(
                            builder: (context) => const Signin(),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Do you have an account? Sign in'),
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
