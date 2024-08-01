import 'package:finalproject/Models/University/school.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';

class SchoolScreen extends StatelessWidget {
  final School school;

  const SchoolScreen({super.key, required this.school});

  @override
  Widget build(BuildContext context) {
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
            _showModalBottomSheet(context, 'School Advisor');
          },
        ),
        CustomButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Majors',
          onPressed: () {
            _showGridModalBottomSheet(
                context, 'University Majors', school.majors);
          },
        ),
      ],
    );
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
        return GridModalBottomSheet(
          title: title,
          items: items,
        );
      },
    );
  }
}
