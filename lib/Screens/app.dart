import 'package:finalproject/Screens/components/profile/index.dart';
import 'package:finalproject/Screens/components/university.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Screens/components/volunteers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  static const _introAnimationEnd = 60 / 240;
  int _pageIndex = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  final List<Widget> _widgetOptions = <Widget>[
    const Center(child: Text('ChatBot')),
    const Volunteers(),
    const UniversityPage(),
    const Index(),
  ];

  void selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
    if (_pageIndex == 0) {
      _controller.reset();
      _controller.animateTo(_introAnimationEnd,
          duration: const Duration(seconds: 1));
    } else {
      _controller.animateTo(_introAnimationEnd,
          duration: const Duration(seconds: 1));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _pageIndex != 1 && _pageIndex != 3 && _pageIndex != 2
          ? AppBar(
              title: Center(
                child: Text(
                  _getPageTitle(_pageIndex),
                ),
              ),
            )
          : null,
      body: IndexedStack(
        index: _pageIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          onTap: selectPage,
          currentIndex: _pageIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedIconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Theme.of(context).colorScheme.primary),
          unselectedIconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Theme.of(context).colorScheme.secondary),
          enableFeedback: false,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          useLegacyColorScheme: true,
          iconSize: 30,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Lottie.asset(
                'assets/animations/starsBlue.json',
                width: 40,
                controller: _controller,
                animate: _pageIndex == 0,
                onLoaded: (composition) => {
                  _controller.animateTo(_introAnimationEnd,
                      duration: const Duration(seconds: 1)),
                },
              ),
              label: 'ChatBot',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.person_2_fill),
              icon: Icon(CupertinoIcons.person_2),
              label: 'Volunteers',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.compass_fill),
              icon: Icon(CupertinoIcons.compass),
              label: 'University',
            ),
            const BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.person_fill),
              icon: Icon(CupertinoIcons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
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
