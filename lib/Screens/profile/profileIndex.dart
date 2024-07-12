import 'package:finalproject/Provider/authProvider.dart';
import 'package:finalproject/Screens/profile/completePage.dart';
import 'package:finalproject/Screens/profile/components/signin.dart';
import 'package:finalproject/Screens/profile/components/signup.dart';
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
    ref.read(authProvider.notifier).checkLoginStatus();
  }

  Future<void> signIn(String email, String password) async {
    await ref.read(authProvider.notifier).signIn(email, password,
        (errorMessage) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    });
    if (ref.read(authProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompleteProfilePage(
            onSignOut: signOut,
          ),
        ),
      );
    }
  }

  Future<void> signOut() async {
    await ref.read(authProvider.notifier).signOut();
    if (!ref.read(authProvider).isLoggedIn) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => CompleteProfilePage(onSignOut: signOut),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    if (authState.isLoading) {
      return Scaffold(
        body: CompleteProfilePage(onSignOut: signOut),
      );
    }
    return Navigator(
      key: _navigatorKey,
      onGenerateRoute: (settings) =>
          _generateRoute(settings, authState.isLoggedIn),
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings, bool isLoggedIn) {
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
          builder: (_) => CompleteProfilePage(
            onSignOut: signOut,
          ),
        );
    }
  }
}
