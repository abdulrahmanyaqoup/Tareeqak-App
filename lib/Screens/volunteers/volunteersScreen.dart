import 'package:dio/dio.dart';
import 'package:finalproject/Screens/volunteers/components/filterVolunteers.dart';
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

class VolunteersScreenState extends ConsumerState<VolunteersScreen> {
  List<User> allUsers = [];
  List<User> filteredUsers = [];
  Future<void>? _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    try {
      await ref.read(userProvider.notifier).getAllUsers();
      setState(() {
        allUsers = ref.read(userProvider).userList;
        filteredUsers = allUsers;
      });
    } on DioException catch (e) {
      if (mounted) {
        CustomSnackBar(
            context: context,
            text: e.message!,
            contentType: ContentType.failure);
      }
    }
  }

  void filterUsers(String? university, String? school, String? major) {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      body: FutureBuilder<void>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: 6,
              itemBuilder: (context, index) {
                return const CardShimmer();
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                FilterVolunteers(
                  onClearFilters: () {
                    setState(() {
                      filteredUsers = allUsers;
                    });
                  },
                  onFilterChanged: (university, school, major) {
                    filterUsers(university, school, major);
                  },
                ),
                filteredUsers.isEmpty
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
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
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
