import 'package:finalproject/Screens/components/university/components/detailBase.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/Models/University/major.dart';
import 'package:finalproject/Screens/components/university/components/universityButtons.dart';
import 'package:url_launcher/url_launcher.dart';

class MajorDetail extends StatelessWidget {
  final Major major;

  const MajorDetail({super.key, required this.major});

  @override
  Widget build(BuildContext context) {
    return DetailBase(
      title: major.name,
      description: major.description,
      facts: [],
      buttons: [
        UniversityButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'Major Advisors',
          onPressed: () {
            _showModalBottomSheet(context, 'Major Advisors');
          },
        ),
        UniversityButtons(
          icon: Icons.list_alt,
          iconColor: Colors.blue,
          label: 'Major Plan',
          onPressed: () {
            _launchURL('');
          },
        ),
        UniversityButtons(
          icon: Icons.work,
          iconColor: Colors.red,
          label: 'Major Jobs',
          onPressed: () {
            _showModalBottomSheet(context, 'Major Jobs');
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


