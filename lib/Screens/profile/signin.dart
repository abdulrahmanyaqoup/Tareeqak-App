import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/userProvider.dart';
import '../../Widgets/customButton.dart';
import '../../Widgets/snackBar.dart';
import '../../Widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'profile.dart';
import 'signup.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({super.key});

  @override
  ConsumerState<Signin> createState() => _Signin();
}

class _Signin extends ConsumerState<Signin> {
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
                  builder: (_) => const Profile(),
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
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
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
                            builder: (_) => const Signup(),
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
