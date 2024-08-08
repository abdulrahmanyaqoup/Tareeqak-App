import 'package:dio/dio.dart';
import 'package:finalproject/Screens/volunteers/components/filterVolunteers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerCard.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Widgets/cardShimmer.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class VolunteersScreen extends ConsumerStatefulWidget {
  const VolunteersScreen({super.key});

  @override
  VolunteersScreenState createState() => VolunteersScreenState();
}

class VolunteersScreenState extends ConsumerState<VolunteersScreen>
    with AutomaticKeepAliveClientMixin {
  List<User> filteredUsers = [];

  @override
  bool get wantKeepAlive => ref.read(userProvider).hasValue;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getAllUsers();
    });
  }

  Future<void> _getAllUsers() async {
    try {
      await ref.read(userProvider.notifier).getAllUsers();
    } on DioException catch (e) {
      if (mounted) {
        showSnackBar(context, e.message!, ContentType.failure);
      }
    }
  }

  void filterUsers(
      List<User> allUsers, String? university, String? school, String? major) {
    setState(() {
      filteredUsers = allUsers.where((user) {
        final matchUniversity =
            university == null || user.userProps.university == university;
        final matchSchool = school == null || user.userProps.school == school;
        final matchMajor = major == null || user.userProps.major == major;
        return matchUniversity && matchSchool && matchMajor;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.4),
      appBar: CupertinoNavigationBar(
        middle: const Text("Contact With Advisors",
            style: TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: userState.when(
        loading: () {
          return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return const CardShimmer();
              });
        },
        error: (error, stackTrace) => Text('Error: $error'),
        data: (userState) {
          if (filteredUsers.isEmpty) {
            setState(() {
              filteredUsers = userState.userList;
            });
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                FilterVolunteers(
                  onClearFilters: () {
                    setState(() {
                      filteredUsers = userState.userList;
                    });
                  },
                  onFilterChanged: (university, school, major) {
                    filterUsers(userState.userList, university, school, major);
                  },
                ),
                userState.userList.isEmpty
                    ? Center(
                        child: Text(
                          'No advisors found',
                          style: TextStyle(
                              fontSize: 20,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: userState.userList.length,
                        itemBuilder: (context, index) {
                          final user = userState.userList[index];
                          return VolunteerCard(user: user);
                        },
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
