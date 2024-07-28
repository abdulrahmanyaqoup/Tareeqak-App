import 'package:finalproject/Screens/components/university/components/bottomSheet.dart';
import 'package:finalproject/Screens/components/university/components/detailBase.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Screens/components/university/components/universityButtons.dart';
import 'package:url_launcher/url_launcher.dart';

class SchoolDetail extends StatelessWidget {
  final School school;

  const SchoolDetail({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
    return DetailBase(
      title: school.name,
      description: school.description,
      facts: school.facts,
      buttons: [
        UniversityButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Majors',
          onPressed: () {
            _showGridModalBottomSheet(context, 'University Majors', school.majors);
          },
        ),
        UniversityButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'School Advisor',
          onPressed: () {
            _showModalBottomSheet(context, 'School Advisor');
          },
        ),
      ],
    );
  }
}

void _launchURL(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri)) {
    throw Exception('Could not launch $url');
  }
}

void _showModalBottomSheet(BuildContext context, String title) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext bc) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Details about $title',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    },
  );
}

void _showGridModalBottomSheet(
    BuildContext context, String title, List<dynamic> items) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return GridModalBottomSheet(title: title, items: items,);
    },
  );
}
