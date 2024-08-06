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
import 'editProfile.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  late Future<void> _loginStatusFuture;

  @override
  void initState() {
    super.initState();
    _loginStatusFuture = _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      await ref.read(userProvider.notifier).checkLoginStatus();
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!, ContentType.failure);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return FutureBuilder<void>(
      future: _loginStatusFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: SizedBox(
              height: 300,
              width: 300,
              child: CardShimmer(showButtons: false),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userState = ref.watch(userProvider);
          final isLoggedIn = userState.isLoggedIn;
          final isLoading = userState.isLoading;
          final buttonText = userState.user.name.isNotEmpty ? 'Edit Profile' : 'Sign Up';
          final greetings = userState.user.name.isNotEmpty
              ? 'Welcome back, ${userState.user.name}'
              : 'Welcome to our community';
          final onPressed = userState.user.name.isNotEmpty
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
                    onPressed: onPressed,
                    isLoading: isLoading,
                    isLoggedIn: isLoggedIn,
                    height: height,
                  ),
                  Positioned(
                    top: height * 0.2 - 60,
                    left: 16,
                    right: 16,
                    child: isLoading
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
      },
    );
  }
}
