import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Provider/userProvider.dart';
import '../../Widgets/cardShimmer.dart';
import '../../Widgets/snackBar.dart';
import 'components/filterVolunteers.dart';
import 'components/volunteerCard.dart';

class VolunteersScreen extends ConsumerStatefulWidget {
  const VolunteersScreen({super.key});

  @override
  ConsumerState<VolunteersScreen> createState() => VolunteersScreenState();
}

class VolunteersScreenState extends ConsumerState<VolunteersScreen>
    with AutomaticKeepAliveClientMixin<VolunteersScreen> {
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

    return Scaffold(
      body: CustomScrollView(
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
                child: FilterVolunteers(
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
                    return VolunteerCard(user: user);
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
