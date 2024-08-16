import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/userProvider.dart';
import '../../widgets/cardShimmer.dart';
import 'components/advisorCard.dart';
import 'components/filterAdvisors.dart';

@immutable
class AdvisorsScreen extends ConsumerStatefulWidget {
  const AdvisorsScreen({super.key});

  @override
  ConsumerState<AdvisorsScreen> createState() => _AdvisorsScreen();
}

class _AdvisorsScreen extends ConsumerState<AdvisorsScreen>
    with AutomaticKeepAliveClientMixin<AdvisorsScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final users = ref.watch(userProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            middle: const Text(
              'Advisors',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            alwaysShowMiddle: false,
            largeTitle: const Text(
              'Advisors',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            border: null,
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
                child: FilterAdvisors(
                  onClearFilters: () {
                    setState(
                      () => ref.read(userProvider.notifier).clearFilters(),
                    );
                  },
                  onFilterChanged: (university, school, major) {
                    ref.read(userProvider.notifier).filterUsers(
                          users.requireValue.userList,
                          university,
                          school,
                          major,
                        );
                  },
                ),
              ),
            ),
          ),
          users.when(
            skipError: true,
            loading: () {
              return SliverList.builder(
                itemBuilder: (context, index) => const CardShimmer(),
                itemCount: 6,
              );
            },
            error: (error, stackTrace) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $error')),
            ),
            data: (userState) {
              if ((users.requireValue.isSearching
                      ? userState.filteredUsers
                      : userState.userList)
                  .isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    heightFactor: 12,
                    child: Text(
                      'No advisors found!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 27,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                return SliverPadding(
                  padding: const EdgeInsets.only(bottom: 10),
                  sliver: SliverList.builder(
                    itemBuilder: (context, index) {
                      final user = userState.filteredUsers.isEmpty
                          ? userState.userList[index]
                          : userState.filteredUsers[index];
                      return AdvisorCard(
                        user: user,
                      );
                    },
                    itemCount: userState.filteredUsers.isEmpty
                        ? userState.userList.length
                        : userState.filteredUsers.length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
