import 'package:finalproject/Screens/profile/components/buttonShimmer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:finalproject/Screens/profile/signup.dart';
import 'package:finalproject/Screens/profile/editProfile.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({
    super.key,
    required this.userState,
    required this.height,
  }); 

  final dynamic userState;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.25),
      height: height * 0.75,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Lottie.asset(
                'assets/animations/logo.json',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            userState.isLoading
                ? const ButtonShimmer(height: 30)
                : Text(
                    userState.isLoggedIn
                        ? 'Welcome back!'
                        : 'Be a part of our community!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            const SizedBox(height: 10),
            userState.isLoading
                ? const ButtonShimmer(height: 60)
                : ElevatedButton(
                    onPressed: () {
                      if (userState.isLoggedIn) {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => const EditProfile(),
                          ),
                        );
                      } else {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      userState.isLoggedIn ? 'Go to Profile' : 'Sign Up',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
