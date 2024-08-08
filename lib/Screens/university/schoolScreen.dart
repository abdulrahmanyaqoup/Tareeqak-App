import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Screens/university/components/volunteersSheet.dart';
import 'package:flutter/material.dart';
import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';

class SchoolScreen extends StatelessWidget {
  final School school;
  final List<User>? universityVolunteers;

  const SchoolScreen(
      {super.key, required this.school, this.universityVolunteers});

  @override
  Widget build(BuildContext context) {
    List<User> schoolVolunteers = universityVolunteers!
        .where((user) => user.userProps.school == school.name)
        .toList();

    return DetailBase(
      title: school.name,
      description: school.description,
      facts: school.facts,
      buttons: [
        CustomButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'School Advisor',
          onPressed: () {
            _showVolunteers(context, 'School Advisor', schoolVolunteers);
          },
        ),
        CustomButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Majors',
          onPressed: () {
            _showGridModalBottomSheet(
                context, 'University Majors', school.majors, schoolVolunteers);
          },
        ),
      ],
    );
  }

  void _showVolunteers(
      BuildContext context, String title, List<User> volunteers) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return VolunteersSheet(
          title: title,
          volunteers: volunteers,
        );
      },
    );
  }

  void _showGridModalBottomSheet(BuildContext context, String title,
      List<dynamic> items, List<User> volunteers) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return GridModalBottomSheet(
          title: title,
          items: items,
          schoolVolunteers: volunteers,
        );
      },
    );
  }
}
