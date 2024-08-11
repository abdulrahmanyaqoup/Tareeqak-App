import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/userProvider.dart';
import '../../widgets/cardShimmer.dart';
import '../../widgets/snackBar.dart';
import '../advisors/components/advisorCard.dart';
import 'components/profileBody.dart';
import 'editProfile.dart';
import 'signup.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile>
    with AutomaticKeepAliveClientMixin<Profile> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_checkLoginStatus);
  }

  Future<void> _checkLoginStatus() async {
    await ref.read(userProvider.notifier).checkLoginStatus().catchError(
          (Object error) => {
            showSnackBar(context, error.toString(), ContentType.failure),
            throw Error(),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final height = MediaQuery.of(context).size.height;
    final getUser = ref.watch(userProvider);

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        border: null,
        padding: EdgeInsetsDirectional.zero,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: getUser.when(
        skipError: true,
        loading: () => Stack(
          children: [
            ProfileBody(
              isLoading: true,
              height: height,
            ),
            Positioned(
              top: height * 0.04,
              left: 16,
              right: 16,
              child: const CardShimmer(showButtons: false),
            ),
          ],
        ),
        error: (error, stackTrace) {
          return const Scaffold();
        },
        data: (userState) {
          final user = userState.user;
          final buttonText = user.name.isNotEmpty ? 'Edit Profile' : 'Sign Up';
          final greetings = user.name.isNotEmpty
              ? 'Welcome back, ${user.name}'
              : 'Become an advisor!';
          final onPressed = user.name.isNotEmpty
              ? () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => EditProfile(user: user),
                    ),
                  )
              : () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const Signup(),
                    ),
                  );

          return Stack(
            children: [
              ProfileBody(
                buttonText: buttonText,
                greeting: greetings,
                onPressed: onPressed,
                height: height,
              ),
              Positioned(
                top: height * 0.04,
                left: 16,
                right: 16,
                child: AdvisorCard(
                  user: userState.user,
                  isProfile: true,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
