import 'package:flutter/material.dart';

class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int pageIndex = 0;
  void selectPage(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    String activePageTitle = 'University';
    Widget activeScreen = const Center(
      child: Text('University Screen'),
    );
    if (pageIndex == 0) {
      activePageTitle = 'Profile';
      activeScreen = const Center(
        child: Text('Profile Screen'),
      ); 
    } else if (pageIndex == 1) {
      activePageTitle = 'Volnteers';
      activeScreen = const Center(
        child: Text('Volunteers Screen'),
      );  
    } else if (pageIndex == 2) {
      activePageTitle = 'ChatBot';
      activeScreen = const Center(
        child: Text('ChatBot Screen'),
      );
    } else if (pageIndex == 3) {
      activePageTitle = 'University';
      activeScreen = const Center(
        child: Text('University Screen'),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            activePageTitle,
          ),
        ),
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: pageIndex,
        selectedIconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).colorScheme.primary),
        unselectedIconTheme: Theme.of(context).iconTheme.copyWith(color: Theme.of(context).colorScheme.secondary),
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
}
