import 'package:flutter/material.dart';
import 'package:finalproject/Screens/components/university/universities.dart';
import 'package:finalproject/Screens/components/university/components/search.dart';

class UniversityPage extends StatefulWidget {
  const UniversityPage({super.key});

  @override
  State<UniversityPage> createState() => _UniversityHomePageState();
}

class _UniversityHomePageState extends State<UniversityPage> {
  late ScrollController _scrollController;
  double _opacity = 1.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          // Calculate opacity based on scroll position
          var offset = _scrollController.offset / 200;
          _opacity = 1 - offset;
          if (_opacity < 0) _opacity = 0;
          if (_opacity > 1) _opacity = 1;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: CustomScrollView(
            controller: _scrollController,
            physics: const ClampingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned:
                    false, // Make AppBar pinned to see the effect while scrolling
                flexibleSpace: FlexibleSpaceBar(
                  title: Opacity(
                    opacity: _opacity, // Use dynamic opacity
                    child: Text(
                      'Universities',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                  background: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 40),
                ),
              ),
              const SliverToBoxAdapter(
                child: Search(),
              ),
              const UniversityGrid(),
            ],
          ),
        ),
      ),
    );
  }
}
