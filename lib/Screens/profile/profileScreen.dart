import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/profile/components/profileBody.dart';
import 'package:finalproject/Screens/profile/signup.dart';
import 'package:finalproject/Widgets/cardShimmer.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerCard.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Models/User/user.dart';
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
  }

  final _loginStatus = FutureProvider<User>((ref) async {
    try {
      return await ref.read(userProvider.notifier).checkLoginStatus();
    } on DioException catch (e) {
      throw e.message!;
    }
  });

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(_loginStatus);
    final double height = MediaQuery.of(context).size.height;

    return user.when(
      loading: () => Container(
        decoration: BoxDecoration(
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
                isLoading: true,
                height: height,
              ),
              Positioned(
                  top: height * 0.2 - 60,
                  left: 16,
                  right: 16,
                  child: const CardShimmer(showButtons: false)),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => Scaffold(
        body: CustomSnackBar(
            context: context,
            text: error.toString(),
            contentType: ContentType.failure),
      ),
      data: (user) {
        final isLoggedIn = user.name.isNotEmpty;
        final buttonText = isLoggedIn ? 'Edit Profile' : 'Sign Up';
        final greetings = isLoggedIn
            ? 'Welcome back, ${user.name}'
            : 'Welcome to our community';
        final onPressed = isLoggedIn
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const EditProfile(),
                  ),
                )
            : () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => const SignupScreen(),
                  ),
                );

        return Container(
          decoration: BoxDecoration(
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
                  isLoading: false,
                  onPressed: onPressed,
                  height: height,
                ),
                Positioned(
                  top: height * 0.2 - 60,
                  left: 16,
                  right: 16,
                  child: VolunteerCard(
                    user: user,
                    isProfile: true,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
