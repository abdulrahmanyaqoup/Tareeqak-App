import 'package:flutter/material.dart';

import '../../Models/University/school.dart';
import '../../Models/User/user.dart';
import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';
import 'components/volunteersSheet.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({
    required this.school,
    super.key,
    this.universityVolunteers,
    this.universityWebsite,
  });
  final School school;
  final List<User>? universityVolunteers;
  final String? universityWebsite;

  @override
  Widget build(BuildContext context) {
    final schoolVolunteers = universityVolunteers!
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
              context,
              'University Majors',
              school.majors,
              schoolVolunteers,
              universityWebsite!,
            );
          },
        ),
      ],
    );
  }

  void _showVolunteers(
    BuildContext context,
    String title,
    List<User> volunteers,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return VolunteersSheet(
          title: title,
          volunteers: volunteers,
        );
      },
    );
  }

  void _showGridModalBottomSheet(
    BuildContext context,
    String title,
    List<dynamic> items,
    List<User> volunteers,
    String universityWebsite,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return GridModalBottomSheet(
          title: title,
          items: items,
          schoolVolunteers: volunteers,
          universityWebsite: universityWebsite,
        );
      },
    );
  }
}
