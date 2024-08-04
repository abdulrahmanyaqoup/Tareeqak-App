import 'package:dio/dio.dart';
import 'package:finalproject/Screens/volunteers/components/filterVolunteers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/volunteers/components/customPaint.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerCard.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Widgets/cardShimmer.dart';

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
      if (mounted) showSnackBar(context, e.message!);
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
      appBar: AppBar(
        title: Text(
          'Contact With Advisors',
          style: TextStyle(
            color: Colors.white.withOpacity(.8),
            fontSize: 20,
          ),
        ),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).appBarTheme.backgroundColor!,
                      Theme.of(context).appBarTheme.backgroundColor!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CustomPaint(
                          painter: CustomIconsPainter(),
                          size: const Size(double.infinity, 150),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Join ambassadors !\n be a model for other students by helping them in their academic year',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
