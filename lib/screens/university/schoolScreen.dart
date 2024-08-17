import 'package:flutter/material.dart';

import '../../model/models.dart';
import 'components/advisorsSheet.dart';
import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';

class SchoolScreen extends StatelessWidget {
  const SchoolScreen({
    required this.school,
    super.key,
    this.universityAdvisors,
    this.universityWebsite,
  });

  final School school;
  final List<User>? universityAdvisors;
  final String? universityWebsite;

  @override
  Widget build(BuildContext context) {
    final schoolAdvisors = universityAdvisors!
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
            _showAdvisors(context, 'School Advisor', schoolAdvisors);
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
              schoolAdvisors,
              universityWebsite!,
            );
          },
        ),
      ],
    );
  }

  void _showAdvisors(
    BuildContext context,
    String title,
    List<User> advisors,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return AdvisorsSheet(
          title: title,
          advisors: advisors,
        );
      },
    );
  }

  void _showGridModalBottomSheet(
    BuildContext context,
    String title,
    List<dynamic> items,
    List<User> advisors,
    String universityWebsite,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return GridModalBottomSheet(
          title: title,
          items: items,
          schoolAdvisors: advisors,
          universityWebsite: universityWebsite,
        );
      },
    );
  }
}
