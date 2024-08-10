import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
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
  ConsumerState<UniversitiesScreen> createState() => UniversitiesScreenState();
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

    return Scaffold(
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
            child: Search(
              onSearchChanged: (query) => ref
                  .read(universityProvider.notifier)
                  .filterUniversities(query),
            ),
          ),
          universities.when(
            loading: () => const UniversityShimmer(),
            error: (error, stackTrace) => const SizedBox.shrink(),
            data: (universities) => UniversitiesGrid(
              universities: universities.filteredUniversities,
            ),
          ),
        ],
      ),
    );
  }
}
