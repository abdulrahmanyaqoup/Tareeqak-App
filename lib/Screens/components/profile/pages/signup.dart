import 'package:finalproject/Screens/components/profile/pages/viewProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Screens/components/profile/pages/signupDetails.dart';
import 'package:finalproject/Widgets/textfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignInPressed;
  const SignupScreen({super.key, required this.onSignInPressed});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
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
        CupertinoPageRoute(
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
      CupertinoPageRoute(
        builder: (context) => ViewProfile(onSignOut: () {}),
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 150),
                  const Text(
                    "Signup",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Enter your name*',
                          prefixIcon: const Icon(CupertinoIcons.person),
                          validator: (value) =>
                              value!.isEmpty ? 'Name can\'t be empty!' : null,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: emailController,
                          hintText: 'Enter your email*',
                          prefixIcon: const Icon(CupertinoIcons.mail),
                          validator: (value) =>
                              value!.isEmpty ? 'Email can\'t be empty!' : null,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: passwordController,
                          hintText: 'Enter your password*',
                          prefixIcon: const Icon(CupertinoIcons.lock),
                          validator: (value) => value!.isEmpty
                              ? 'Password can\'t be empty!'
                              : null,
                          obscureText: !_isPasswordVisible,
                          suffixIcon: IconButton(
                            highlightColor: Colors.transparent,
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
                              return 'Confirm Password can\'t be empty!';
                            } else if (value != passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          },
                          obscureText: !_isConfirmPasswordVisible,
                          suffixIcon: IconButton(
                            highlightColor: Colors.transparent,
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
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: goToOptionalSignup,
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            minimumSize: WidgetStateProperty.all(
                                const Size(double.infinity, 50)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: widget.onSignInPressed,
                          child: const Text('Do you have an account? Sign in'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
