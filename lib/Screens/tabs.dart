import 'package:finalproject/Screens/profile/profileIndex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Screens/volunteers.dart';

class Tabs extends ConsumerStatefulWidget {
  const Tabs({super.key});

  @override
  TabsState createState() => TabsState();
}

class TabsState extends ConsumerState<Tabs> {
  int _pageIndex = 0;
  bool _isLoading = true;
  bool token = false;

  static final List<Widget> _widgetOptions = <Widget>[
    const Index(),
    const Volunteers(),
    const Center(
      child: Text("chatbot"),
    ),
    const Center(
      child: Text("university"),
    ),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = false;
    });
  }

  void selectPage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _pageIndex != 0 && _pageIndex != 1
          ? AppBar(
              title: Center(
                child: Text(
                  _getPageTitle(_pageIndex),
                ),
              ),
            )
          : null,
      body: Center(child: _widgetOptions.elementAt(_pageIndex)),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: _pageIndex,
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
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_2),
            label: 'Volunteers',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text),
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
      case 1:
        return 'University';
      case 2:
        return 'Volunteers';
      case 3:
        return 'ChatBot';
      default:
        return 'University';
    }
  }
}
