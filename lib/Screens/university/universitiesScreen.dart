import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/universityProvider.dart';
import '../../Utils/getUniversities.dart';
import '../../Widgets/snackBar.dart';
import 'components/search.dart';
import 'components/universitiesGrid.dart';
import 'components/universityShimmer.dart';

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
  double _opacity = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(_getUniversities);
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

  Future<void> _getUniversities() async {
    await getUniversities(ref).catchError(
      (Object error) => {
        showSnackBar(context, error.toString(), ContentType.failure),
        throw Error(),
      },
    );
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

    return ColoredBox(
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
                expandedHeight: 120,
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
                  onSearchChanged: (query) => ref
                      .read(universityProvider.notifier)
                      .filterUniversities(query),
                ),
              ),
              universities.when(
                loading: () => const UniversityShimmer(),
                error: (error, stackTrace) => const SliverToBoxAdapter(),
                data: (universities) => UniversitiesGrid(
                  universities: universities.filteredUniversities,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
