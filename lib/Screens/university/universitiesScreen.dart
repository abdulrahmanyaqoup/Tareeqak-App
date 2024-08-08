import 'package:dio/dio.dart';
import 'package:finalproject/Models/University/university.dart';
import 'package:finalproject/Screens/university/components/universitiesGrid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'components/universityShimmer.dart';
import '../../Provider/universityProvider.dart';
import 'components/search.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  UniversitiesScreenState createState() => UniversitiesScreenState();
}

class UniversitiesScreenState extends ConsumerState<UniversitiesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  double _opacity = 1.0;
  List<University> filteredUniversities = [];

  @override
  void initState() {
    super.initState();
    _getUniversities();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          var offset = _scrollController.offset / 200;
          _opacity = 1 - offset;
          if (_opacity < 0) _opacity = 0;
          if (_opacity > 1) _opacity = 1;
        });
      });
  }

  Future<void> _getUniversities() async {
    try {
      await ref.read(universityProvider.notifier).getUniversities();
      setState(() {
        filteredUniversities = ref.read(universityProvider).universities;
      });
    } on DioException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _filterUniversities(String query) {
    final universityState = ref.read(universityProvider);
    if (query.isEmpty) {
      setState(() {
        filteredUniversities = universityState.universities;
      });
    } else {
      setState(() {
        filteredUniversities = universityState.universities
            .where((university) =>
                university.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final universityState = ref.watch(universityProvider);

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
                pinned: false,
                flexibleSpace: FlexibleSpaceBar(
                  title: Opacity(
                    opacity: _opacity,
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
              SliverToBoxAdapter(
                child: Search(
                  onSearchChanged: _filterUniversities,
                ),
              ),
              universityState.isLoading
                  ? const UniversityShimmer()
                  : UniversitiesGrid(
                      universities: filteredUniversities,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
