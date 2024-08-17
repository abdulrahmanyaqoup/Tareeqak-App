import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/customButton.dart';
import '../../Widgets/snackBar.dart';
import '../../Widgets/textfield.dart';
import '../../provider/userProvider.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'profileScreen.dart';
import 'registerScreen.dart';
import 'resetPassScreen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _signIn(String email, String password) async {
    setState(() => _isLoading = true);
    await ref
        .read(userProvider.notifier)
        .signIn(email, password)
        .then(
          (response) => {
            setState(() => _isLoading = false),
            if (mounted)
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute<void>(
                  builder: (_) => const ProfileScreen(),
                ),
                (Route<dynamic> route) => false,
              ),
          },
        )
        .catchError(
          (Object error, stackTrace) => {
            showSnackBar(error.toString(), ContentType.failure),
            setState(() => _isLoading = false),
            throw Error(),
          },
        );
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
                const SizedBox(height: 80),
                const Text(
                  'Signin',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      CustomTextField(
                        autoFillHints: const [
                          AutofillHints.email,
                          AutofillHints.username,
                        ],
                        keyboardType: TextInputType.emailAddress,
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
                        autoFillHints: const [AutofillHints.password],
                        keyboardType: TextInputType.visiblePassword,
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
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.of(context).push(
                            CupertinoPageRoute<void>(
                              builder: (_) => const ResetPassScreen(),
                            ),
                          ),
                          child: const Text(
                            textAlign: TextAlign.right,
                            'Reset password',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomButton(
                        isLoading: _isLoading,
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
                            builder: (_) => const RegisterScreen(),
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
