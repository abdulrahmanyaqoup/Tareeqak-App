import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/universityProvider.dart';
import '../../widgets/search.dart';
import 'components/universitiesGrid.dart';
import 'components/universityShimmer.dart';

class UniversitiesScreen extends ConsumerStatefulWidget {
  const UniversitiesScreen({super.key});

  @override
  ConsumerState<UniversitiesScreen> createState() => _UniversitiesScreen();
}

class _UniversitiesScreen extends ConsumerState<UniversitiesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late ScrollController _scrollController;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          final offset = _scrollController.offset / 200;
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
    super.build(context);
    final universities = ref.watch(universityProvider);

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            middle: const Text(
              'Universities',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            alwaysShowMiddle: false,
            largeTitle: const Text(
              'Universities',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            brightness: Brightness.dark,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
          SliverToBoxAdapter(
            child: ColoredBox(
              color: Theme.of(context).colorScheme.primary,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 5,
                    top: 20,
                    left: 15,
                    right: 15,
                  ),
                  child: Search(
                    onSearchChanged: (query) => ref
                        .read(universityProvider.notifier)
                        .filterUniversities(query),
                    hintText: 'Search for a university',
                  ),
                ),
              ),
            ),
          ),
          universities.when(
            loading: () => const UniversityShimmer(),
            error: (error, stackTrace) => const SizedBox.shrink(),
            data: (universities) => UniversitiesGrid(
              universities: universities.isSearching
                  ? universities.filteredUniversities
                  : universities.universities,
            ),
          ),
        ],
      ),
    );
  }
}
