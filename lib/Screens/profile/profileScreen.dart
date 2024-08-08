import 'package:finalproject/Screens/profile/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Provider/userProvider.dart';
import '../../Widgets/cardShimmer.dart';
import '../volunteers/components/volunteerCard.dart';
import 'components/profileBody.dart';
import 'editProfile.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProvider.notifier).checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final asyncUser = ref.watch(userProvider);
    final double height = MediaQuery.of(context).size.height;

    return asyncUser.when(
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
                isLoading: asyncUser.isLoading,
                height: height,
              ),
              Positioned(
                top: height * 0.2 - 60,
                left: 16,
                right: 16,
                child: const CardShimmer(showButtons: false),
              ),
            ],
          ),
        ),
      ),
      error: (error, stackTrace) => Container(),
      data: (userState) {
        final user = userState.user;
        final isLoggedIn = userState.isLoggedIn;
        final buttonText = isLoggedIn ? 'Edit Profile' : 'Sign Up';
        final greetings = isLoggedIn
            ? 'Welcome back, ${user.name}'
            : 'Welcome to our community';
        final onPressed = isLoggedIn
            ? () => Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => EditProfile(user: user),
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
                  isLoading: asyncUser.isLoading,
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
