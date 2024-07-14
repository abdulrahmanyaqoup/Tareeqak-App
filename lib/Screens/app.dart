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

class _BottomNavigationState extends ConsumerState<BottomNavigation> {
  int _pageIndex = 3;

  final List<Widget> _widgetOptions = <Widget>[
     Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
           const Text(
            'AstroNet is under prgress waiting Abdulrahman AlDumairi to finish it :()',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF4A4B7B), 
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 50),
          Lottie.asset(
            'assets/animations/astronet.json',
            width: 200,
            height: 200,
            repeat: true,
            animate: true,
          ),
        ],
      ),
    ),
    const Volunteers(),
    const UniversityPage(),
    const Index(),
  ];

  void selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
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
        child: SizedBox(
          height: 70,
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
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 30,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: _pageIndex == 0
                    ? Lottie.asset('assets/animations/starsBlue.json',
                        width: 80, height: 36, repeat: true, animate: true)
                    : Image.asset('assets/animations/images/starsStatic.png',
                    width: 80, height: 29),
                label: 'ChatBot',
              ),
              BottomNavigationBarItem(
                icon: Icon(_pageIndex == 1
                    ? CupertinoIcons.person_2_fill
                    : CupertinoIcons.person_2),
                label: 'Volunteers',
              ),
              BottomNavigationBarItem(
                icon: Icon(_pageIndex == 2
                    ? CupertinoIcons.compass_fill
                    : CupertinoIcons.compass),
                label: 'University',
              ),
              BottomNavigationBarItem(
                icon: Icon(_pageIndex == 3
                    ? CupertinoIcons.person_fill
                    : CupertinoIcons.person),
                label: 'Profile',
              ),
            ],
          ),
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
