import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'Screens/profile/profileScreen.dart';
import 'Screens/university/universitiesScreen.dart';
import 'Screens/volunteers/volunteersScreen.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const int _defaultPageIndex = 3;
  static const _introAnimationEnd = 60 / 240;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text('ChatBot')),
    const VolunteersScreen(),
    const UniversitiesScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 0.05,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        inactiveColor: Theme.of(context).colorScheme.primary,
        onTap: (index) => {
          if (index == 0)
            {
              _controller.reset(),
              _controller.animateTo(
                _introAnimationEnd,
                duration: const Duration(seconds: 1),
              ),
            }
        },
        currentIndex: _defaultPageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Lottie.asset(
              'assets/animations/stars.json',
              height: 35,
              width: 35,
              fit: BoxFit.fill,
              animate: false,
              controller: _controller,
              onLoaded: (composition) => {
                _controller.animateTo(_introAnimationEnd,
                    duration: const Duration(seconds: 1)),
              },
            ),
            activeIcon: Lottie.asset(
              'assets/animations/starsFilled.json',
              height: 35,
              width: 35,
              fit: BoxFit.fill,
              controller: _controller,
              animate: false,
              onLoaded: (composition) => {
                _controller.animateTo(_introAnimationEnd,
                    duration: const Duration(seconds: 1)),
              },
            ),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            activeIcon: Icon(CupertinoIcons.person_2_fill),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.compass),
            activeIcon: Icon(CupertinoIcons.compass_fill),
          ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            activeIcon: Icon(CupertinoIcons.person_fill),
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return CupertinoPageScaffold(
              navigationBar: index != 3 && index != 2
                  ? CupertinoNavigationBar(
                      middle: index == 0
                          ? Text(_getPageTitle(index))
                          : const Text("Contact with Advisors"),
                    )
                  : null,
              child: IndexedStack(
                index: index,
                children: _widgetOptions,
              ),
            );
          },
        );
      },
    );
  }

  String _getPageTitle(int index) {
    switch (index) {
      case 0:
        return 'ChatBot';
      case 1:
        return 'Volunteers';
      case 2:
        return 'University';
      case 3:
      default:
        return 'Profile';
    }
  }
}
