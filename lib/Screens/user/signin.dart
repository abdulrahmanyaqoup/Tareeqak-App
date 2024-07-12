import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Widgets/textfield.dart';

class Signin extends ConsumerStatefulWidget {
  final VoidCallback onSignUpPressed;
  final Function(String, String) onSignIn;

  const Signin(
      {super.key, required this.onSignUpPressed, required this.onSignIn});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends ConsumerState<Signin> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 150),
            const Text(
              "Login",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _emailController,
                hintText: 'Enter your email*',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: _passwordController,
                hintText: 'Enter your password*',
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.onSignIn(
                      _emailController.text, _passwordController.text);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Login",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () => widget.onSignUpPressed(),
              child: const Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
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
