import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/userProvider.dart';
import '../../widgets/cardShimmer.dart';
import '../../widgets/snackBar.dart';
import '../advisors/components/advisorCard.dart';
import 'components/profileBody.dart';
import 'editProfileScreen.dart';
import 'manualScreen.dart';
import 'registerScreen.dart';

@immutable
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends ConsumerState<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
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
            showSnackBar(error.toString(), ContentType.failure),
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
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
        trailing: IconButton(
          icon: const Icon(
            CupertinoIcons.question_circle,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () => Navigator.push(
            context,
            CupertinoPageRoute<void>(
              builder: (_) => const ManualScreen(
                isProfile: true,
              ),
            ),
          ),
        ),
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
              child: const CardShimmer(showButtons: false, isProfile: true),
            ),
          ],
        ),
        error: (error, stackTrace) {
          return const Scaffold();
        },
        data: (userState) {
          final user = userState.user;
          final buttonText = user.name.isNotEmpty ? 'Edit Profile' : 'Register';
          final greetings = user.name.isNotEmpty
              ? 'Welcome back, ${user.name}'
              : 'Become an advisor!';
          final onPressed = user.name.isNotEmpty
              ? () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => EditProfileScreen(user: user),
                    ),
                  )
              : () => Navigator.push(
                    context,
                    CupertinoPageRoute<void>(
                      builder: (_) => const RegisterScreen(),
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
