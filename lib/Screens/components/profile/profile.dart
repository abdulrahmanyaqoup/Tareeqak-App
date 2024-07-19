import 'package:dio/dio.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/components/profile/pages/signin.dart';
import 'package:finalproject/Screens/components/profile/pages/signup.dart';
import 'package:finalproject/Screens/components/profile/pages/viewProfile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  _Profile createState() => _Profile();
}

class _Profile extends ConsumerState<Profile> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn(String email, String password) async {
    try {
      await ref.read(userProvider.notifier).signIn(email, password);
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!);
    }
    if (ref.read(userProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => viewProfile(
            onSignOut: signOut,
          ),
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await ref.read(userProvider.notifier).signOut();
    } catch (e) {
      if (mounted) showSnackBar(context, e.toString());
    }
    if (!ref.read(userProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => viewProfile(onSignOut: signOut),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) => _generateRoute(settings),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/signin':
        return CupertinoPageRoute(
          builder: (_) => Signin(
            onSignIn: signIn,
            onSignUpPressed: () {
              _navigatorKey.currentState?.pushNamed('/signup');
            },
          ),
        );
      case '/signup':
        return CupertinoPageRoute(
          builder: (_) => SignupScreen(
            onSignInPressed: () {
              _navigatorKey.currentState?.pushNamed('/signin');
            },
          ),
        );
      case '/Profile':
      default:
        return CupertinoPageRoute(
          builder: (_) => viewProfile(
            onSignOut: signOut,
          ),
        );
    }
  }
}
