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
  List<User> filteredUsers = [];
  bool? matchUniversity;
  bool? matchSchool;
  bool? matchMajor;

  @override
  void initState() {
    super.initState();
    _getAllUsers();
  }

  Future<void> _getAllUsers() async {
    try {
      await ref.read(userProvider.notifier).getAllUsers();
      filterUsers(null, null, null);
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!, ContentType.failure);
    }
  }

  void filterUsers(String? university, String? school, String? major) {
    final users = ref.read(userProvider).userList;
    setState(() {
      filteredUsers = users.where((user) {
        matchUniversity =
            university == null || user.userProps.university == university;
        matchSchool = school == null || user.userProps.school == school;
        matchMajor = major == null || user.userProps.major == major;
        return matchUniversity! && matchSchool! && matchMajor!;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProvider).isLoading;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),

      body: SingleChildScrollView(
        child: Column(
          children: [
            FilterVolunteers(
              onClearFilters: (){
                filterUsers(null, null, null);
              },
              onFilterChanged: (university, school, major) {
                filterUsers(university, school, major);
              },
            ),
            isLoading
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 6,
                    itemBuilder: (context, index) {
                      return const CardShimmer();
                    },
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
      ),
    );
  }
}
