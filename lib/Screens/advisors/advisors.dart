import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/userProvider.dart';
import '../../widgets/cardShimmer.dart';
import '../../widgets/snackBar.dart';
import 'components/advisorCard.dart';
import 'components/filterAdvisors.dart';

class Advisors extends ConsumerStatefulWidget {
  const Advisors({super.key});

  @override
  ConsumerState<Advisors> createState() => _AdvisorsState();
}

class _AdvisorsState extends ConsumerState<Advisors>
    with AutomaticKeepAliveClientMixin<Advisors> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_getAllUsers);
  }

  Future<void> _getAllUsers() async {
    await ref.read(userProvider.notifier).getAllUsers().catchError(
          (Object error) => {
            showSnackBar(context, error.toString(), ContentType.failure),
            throw Error(),
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final users = ref.watch(userProvider);

    return CupertinoPageScaffold(
      child: CustomScrollView(
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
                    setState(() {
                      ref.read(userProvider);
                      users.valueOrNull!.filteredUsers =
                          users.valueOrNull!.userList;
                    });
                  },
                  onFilterChanged: (university, school, major) {
                    ref.read(userProvider.notifier).filterUsers(
                          ref.read(userProvider).valueOrNull!.userList,
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
              if (userState.filteredUsers.isEmpty) {
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
                return SliverList.builder(
                  itemBuilder: (context, index) {
                    final user = userState.filteredUsers[index];
                    return AdvisorCard(
                      user: user,
                    );
                  },
                  itemCount: userState.filteredUsers.length,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
