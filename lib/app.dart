import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import 'Screens/chatbot/chatbot.dart';
import 'Screens/profile/profileScreen.dart';
import 'Screens/university/universitiesScreen.dart';
import 'Screens/volunteers/volunteersScreen.dart';
import 'Utils/getUniversities.dart';

class BottomNavigation extends ConsumerStatefulWidget {
  const BottomNavigation({super.key});

  @override
  ConsumerState<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends ConsumerState<BottomNavigation>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  static const _introAnimationEnd = 60 / 240;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => getUniversities(ref));
    _tabController = TabController(
      vsync: this,
      initialIndex: 3,
      length: _navigatorKeys.length,
    );
    _controller = AnimationController(vsync: this);
  }

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  @override
  void dispose() {
    _tabController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _tabController.animateTo(
        index,
        curve: Curves.easeInOutCubic,
      );
    });

    if (_tabController.index == 0) {
      _controller
        ..reset()
        ..animateTo(
          _introAnimationEnd,
          duration: const Duration(seconds: 1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildNavigator(0, const ChatBot()),
          _buildNavigator(1, const VolunteersScreen()),
          _buildNavigator(2, const UniversitiesScreen()),
          _buildNavigator(3, const ProfileScreen()),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 0.05,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        inactiveColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        currentIndex: _tabController.index,
        items: [
          BottomNavigationBarItem(
            icon: Lottie.asset(
              'assets/animations/stars.json',
              height: 35,
              width: 35,
              fit: BoxFit.fill,
              animate: false,
              controller: _controller,
              onLoaded: (composition) {
                _controller.animateTo(
                  _introAnimationEnd,
                  duration: const Duration(seconds: 1),
                );
              },
            ),
            activeIcon: Lottie.asset(
              'assets/animations/starsFilled.json',
              height: 35,
              width: 35,
              fit: BoxFit.fill,
              controller: _controller,
              animate: false,
              onLoaded: (composition) {
                _controller.animateTo(
                  _introAnimationEnd,
                  duration: const Duration(seconds: 1),
                );
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
    );
  }

  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (routeSettings) {
        return CupertinoPageRoute(
          builder: (context) => child,
        );
      },
    );
  }
}
