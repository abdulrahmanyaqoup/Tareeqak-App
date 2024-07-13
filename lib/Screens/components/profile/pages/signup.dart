import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Screens/components/profile/pages/signupExtended.dart';
import 'package:finalproject/Widgets/textfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignInPressed;
  const SignupScreen({super.key, required this.onSignInPressed});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  void goToOptionalSignup() {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupOptionalScreen(
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
          ),
        ),
      );
    } else if (emailController.text.isEmpty &&
        passwordController.text.isEmpty &&
        nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all the fields'),
        ),
      );
    } else if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your name'),
        ),
      );
    } else if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
        ),
      );
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your password'),
        ),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const Text(
              "Signup",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: nameController,
                hintText: 'Enter your name*',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: emailController,
                hintText: 'Enter your email*',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: passwordController,
                hintText: 'Enter your password*',
                obscureText: true,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: goToOptionalSignup,
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
                "Next",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            TextButton(
              onPressed: () => widget.onSignInPressed(),
              child: const Text('Login User?'),
            ),
          ],
        ),
      ),
    );
  }
}
