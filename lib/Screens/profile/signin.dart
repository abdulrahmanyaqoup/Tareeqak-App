import 'package:dio/dio.dart';
import 'package:finalproject/Screens/profile/profileScreen.dart';
import 'package:finalproject/Screens/profile/signup.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Provider/userProvider.dart';
import '../../../Utils/utils.dart';

class Signin extends ConsumerStatefulWidget {
  const Signin({
    super.key,
  });

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
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!);
    }
    if (ref.read(userProvider).isLoggedIn && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
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
                children: <Widget>[
                  const SizedBox(height: 150),
                  const Text(
                    "Login",
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
                          controller: _emailController,
                          hintText: 'Enter your email*',
                          prefixIcon: const Icon(CupertinoIcons.mail),
                          validator: (value) =>
                              value!.isEmpty ? 'Email can\'t be empty!' : null,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Enter your password*',
                          prefixIcon: const Icon(CupertinoIcons.lock),
                          validator: (value) => value!.isEmpty
                              ? 'Password can\'t be empty!'
                              : null,
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
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _signIn(_emailController.text,
                                  _passwordController.text);
                            }
                          },
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
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () =>
                              Navigator.of(context).pushReplacement(
                            CupertinoPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text('Don\'t have an account? Sign up'),
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
