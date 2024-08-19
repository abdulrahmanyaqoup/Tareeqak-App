import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/customButton.dart';
import '../../Widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'loginScreen.dart';
import 'regDetailsScreen.dart';

@immutable
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _goToRegisterDetails() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      CupertinoPageRoute<void>(
        builder: (context) => RegDetailsScreen(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                  'Register',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      CustomTextField(
                        autoFillHints: const [AutofillHints.name],
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        hintText: 'Enter your name',
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
                        autoFillHints: const [
                          AutofillHints.email,
                          AutofillHints.newUsername,
                        ],
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                        hintText: 'Enter your university email',
                        prefixIcon: const Icon(CupertinoIcons.mail),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty!";
                          } else if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(edu)\'
                                  r'.jo$')
                              .hasMatch(value)) {
                            return 'Enter a valid university email address!';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        autoFillHints: const [AutofillHints.newPassword],
                        keyboardType: TextInputType.visiblePassword,
                        controller: _passwordController,
                        hintText: 'Enter your password',
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
                          onPressed: () => setState(
                            () => _isPasswordVisible = !_isPasswordVisible,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        autoFillHints: const [AutofillHints.newPassword],
                        keyboardType: TextInputType.visiblePassword,
                        controller: _confirmPasswordController,
                        hintText: 'Confirm your password',
                        prefixIcon: const Icon(CupertinoIcons.lock),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirm Password can't be empty!";
                          } else if (value != _passwordController.text) {
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
                            setState(
                              () => _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        textColor: Colors.white,
                        onPressed: _goToRegisterDetails,
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
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: const Text('Do you have an account? Login'),
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
