import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Screens/user/profile.dart';
import 'package:finalproject/Screens/user/signup.dart';
import 'package:finalproject/Screens/user/signin.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Screens/volunteers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends ConsumerState<Tabs> {
  final AuthService authService = AuthService();
  int pageIndex = 1;
  bool isLoading = true;
  bool isLoggedIn = false;
  String token = '';

  void selectPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      token = prefs.getString('x-auth-token') ?? '';
      if (token.isNotEmpty) {
        authService.getUserData(context: context, ref: ref);
      }
      setState(() async {
        isLoading = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: pageIndex != 0 && pageIndex != 1
          ? AppBar(
              title: Center(
                child: Text(
                  _getPageTitle(pageIndex),
                ),
              ),
            )
          : null,
      body: Navigator(
        key: GlobalKey<NavigatorState>(),
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => _getActiveScreen(pageIndex, token);
              break;
            case '/signin':
              builder = (BuildContext _) => _getActiveScreen(pageIndex, token);
              break;
            default:
              throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: pageIndex,
        selectedIconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).colorScheme.primary),
        unselectedIconTheme: Theme.of(context)
            .iconTheme
            .copyWith(color: Theme.of(context).colorScheme.secondary),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.volunteer_activism),
            label: 'Volunteers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'ChatBot',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'University',
          ),
        ],
      ),
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'Profile';
      case 2:
        return 'ChatBot';
      case 3:
        return 'University';
      default:
        return 'University';
    }
  }

  Widget _getActiveScreen(int index, String token) {
    switch (index) {
      case 0:
        return token.isNotEmpty ? const Profile() : const SignupScreen();
      case 1:
        return const Volunteers();
      case 2:
        return const Center(child: Text('ChatBot Screen'));
      case 3:
        return const Center(child: Text('University Screen'));
      default:
        return const Center(child: Text('University Screen'));
    }
  }
}
