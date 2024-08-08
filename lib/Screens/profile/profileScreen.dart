import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:finalproject/Screens/profile/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/cupertino.dart';
import '../../Provider/userProvider.dart';
import '../../Widgets/snackBar.dart';
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
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkLoginStatus());
  }

  Future<void> _checkLoginStatus() async {
    await ref
        .read(userProvider.notifier)
        .checkLoginStatus()
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString(), ContentType.failure);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double height = MediaQuery.of(context).size.height;
    final getUser = ref.watch(userProvider);

    return getUser.when(
      skipError: true,
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
        child: Stack(
          children: [
            ProfileBody(
              isLoading: true,
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
      error: (error, stackTrace) {
        return const Scaffold();
      },
      data: (userState) {
        final user = userState.user;
        final buttonText = user.name.isNotEmpty ? 'Edit Profile' : 'Sign Up';
        final greetings = user.name.isNotEmpty
            ? 'Welcome back, ${user.name}'
            : 'Welcome to our community';
        final onPressed = user.name.isNotEmpty
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
          child: Stack(
            children: [
              ProfileBody(
                buttonText: buttonText,
                greeting: greetings,
                onPressed: onPressed,
                height: height,
              ),
              Positioned(
                top: height * 0.2 - 60,
                left: 16,
                right: 16,
                child: VolunteerCard(
                  user: userState.user,
                  isProfile: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
