import 'package:dio/dio.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/profile/components/profileBody.dart';
import 'package:finalproject/Screens/profile/signup.dart';
import 'package:finalproject/Widgets/cardShimmer.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerCard.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'editProfile.dart';


class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      await ref.read(userProvider.notifier).checkLoginStatus();
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final bool isLoading = userState.isLoading;
    final bool isLoggedIn = userState.isLoggedIn;
    final String greetings = isLoggedIn ? 'Welcome back!' : 'Be a part of our community!';
    final String buttonText = isLoggedIn ? 'Edit Profile' : 'Sign Up';
    final Function() onPressed = isLoggedIn
        ? () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const EditProfile(),
              ),
            )
        : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignupScreen(),
              ),
            );

    final double height = MediaQuery.of(context).size.height;
    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topRight,
          end: Alignment.topLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            ProfileBody(
                buttonText: buttonText,
                greeting: greetings,
                onPressed: onPressed,
                isLoading: isLoading,
                isLoggedIn: isLoggedIn,
                height: height),
            Positioned(
              top: height * 0.2 - 60,
              left: 16,
              right: 16,
              child: userState.isLoading
                  ? const CardShimmer(showButtons: false)
                  : VolunteerCard(
                      user: userState.user,
                      isProfile: true,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
