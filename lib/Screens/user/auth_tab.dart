import 'package:finalproject/Provider/auth_state.dart';
import 'package:finalproject/Screens/user/profile.dart';
import 'package:finalproject/Screens/user/signin.dart';
import 'package:finalproject/Screens/user/signup.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthTab extends ConsumerStatefulWidget {
  const AuthTab({super.key});

  @override
  _AuthTabState createState() => _AuthTabState();
}

class _AuthTabState extends ConsumerState<AuthTab> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final AuthService authService = AuthService();

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
    if (ref.read(authProvider)) {
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
    await ref.read(authProvider.notifier).signOut();
    if (!ref.read(authProvider)) {
      _navigatorKey.currentState?.pushReplacement(
        MaterialPageRoute(
          builder: (_) => Signin(
            onSignUpPressed: () {
              _navigatorKey.currentState?.pushReplacementNamed('/signup');
            },
            onSignIn: signIn,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(authProvider.notifier).checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          authService.getUserData(context: context, ref: ref);
          final isLoggedIn = ref.watch(authProvider);
          return Navigator(
            onGenerateRoute: (settings) => _generateRoute(settings, isLoggedIn),
          );
        } else {
          return const CircularProgressIndicator(); // Or any other loading indicator
        }
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings, bool isLoggedIn) {
    if (isLoggedIn) {
      return MaterialPageRoute(
        builder: (_) => Profile(
          onSignOut: signOut,
        ),
      );
    } else {
      switch (settings.name) {
        case '/signup':
          return MaterialPageRoute(
            builder: (_) => SignupScreen(
              onSignInPressed: () {
                _navigatorKey.currentState?.pushReplacementNamed('/signin');
              },
            ),
          );
        case '/signin':
        default:
          return MaterialPageRoute(
            builder: (_) => Signin(
              onSignUpPressed: () {
                _navigatorKey.currentState?.pushReplacementNamed('/signup');
              },
              onSignIn: signIn,
            ),
          );
      }
    }
  }
}
