import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/userProvider.dart';
import '../../Widgets/customButton.dart';
import '../../Widgets/snackBar.dart';
import '../../Widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/gradientBackground.dart';
import 'profileScreen.dart';
import 'signup.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  SigninState createState() => SigninState();
}

class SigninState extends ConsumerState<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _signIn(String email, String password) async {
    try {
      await ref.read(userProvider.notifier).signIn(email, password);
      if (!mounted) return;
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => const ProfileScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      final errorMessage = error.toString().replaceFirst('Exception: ', '');
      showSnackBar(context, errorMessage, ContentType.failure);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                const HeaderText(text: 'Login'),
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
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Enter your password*',
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password can't be empty!";
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
                      CustomButton(
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _signIn(
                              _emailController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        text: 'Login',
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.of(context).pushReplacement(
                          CupertinoPageRoute<void>(
                            builder: (_) => const SignupScreen(),
                          ),
                        ),
                        child: const Text("Don't have an account? Sign up"),
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
