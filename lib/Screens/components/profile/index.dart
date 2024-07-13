import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/components/profile/pages/profile.dart';
import 'package:finalproject/Screens/components/profile/pages/signin.dart';
import 'package:finalproject/Screens/components/profile/pages/signup.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  _Index createState() => _Index();
}

class _Index extends ConsumerState<Index> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> signIn(String email, String password) async {
    try {
      await ref.read(userProvider.notifier).signIn(email, password);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    if (ref.read(userProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => Profile(
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
      showSnackBar(context, e.toString());
    }
    if (!ref.read(userProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => Profile(onSignOut: signOut),
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
        return MaterialPageRoute(
          builder: (_) => Signin(
            onSignIn: signIn,
            onSignUpPressed: () {
              _navigatorKey.currentState?.pushNamed('/signup');
            },
          ),
        );
      case '/signup':
        return MaterialPageRoute(
          builder: (_) => SignupScreen(
            onSignInPressed: () {
              _navigatorKey.currentState?.pushNamed('/signin');
            },
          ),
        );
      case '/Profile':
      default:
        return MaterialPageRoute(
          builder: (_) => Profile(
            onSignOut: signOut,
          ),
        );
    }
  }
}
