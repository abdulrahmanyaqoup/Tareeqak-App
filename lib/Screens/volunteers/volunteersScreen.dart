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
  VolunteersScreenState createState() => VolunteersScreenState();
}

class VolunteersScreenState extends ConsumerState<VolunteersScreen>
    with AutomaticKeepAliveClientMixin<VolunteersScreen> {
  @override
  bool get wantKeepAlive => ref.read(userProvider).hasValue;

  @override
  void initState() {
    super.initState();
    Future.microtask(_getAllUsers);
  }

  Future<void> _getAllUsers() async {
    await ref
        .read(userProvider.notifier)
        .getAllUsers()
        .onError((error, stackTrace) {
      showSnackBar(context, error.toString(), ContentType.failure);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final users = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      appBar: CupertinoNavigationBar(
        middle: const Text('Contact With Advisors',
            style: TextStyle(color: Colors.white, fontSize: 17),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: RefreshIndicator(
        onRefresh: _getAllUsers,
        child: users.when(
          skipError: true,
          loading: () {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return const CardShimmer();
                },);
          },
          error: (error, stackTrace) => Text('Error: $error'),
          data: (userState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  FilterVolunteers(
                    onClearFilters: () {
                      setState(() {
                        userState.filteredUsers = userState.userList;
                      });
                    },
                    onFilterChanged: (university, school, major) {
                      ref.read(userProvider.notifier).filterUsers(
                          userState.userList, university, school, major,);
                    },
                  ),
                  if (userState.filteredUsers.isEmpty) Center(
                          child: Text(
                            'No advisors found',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,),
                          ),
                        ) else ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: userState.filteredUsers.length,
                          itemBuilder: (context, index) {
                            final user = userState.filteredUsers[index];
                            return VolunteerCard(user: user);
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
