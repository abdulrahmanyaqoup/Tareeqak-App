import 'package:finalproject/Models/University/university.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';

class UniversityScreen extends StatelessWidget {
  final University university;

  const UniversityScreen({super.key, required this.university});

  @override
  Widget build(BuildContext context) {
    return DetailBase(
      title: university.name,
      description: university.description,
      city: 'Amman',
      universityType: 'Public',
      facts: university.facts,
      buttons: [
        CustomButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'University Advisors',
          onPressed: () {
            _showModalBottomSheet(context, 'University Advisors');
          },
        ),
        CustomButtons(
          icon: Icons.location_on,
          iconColor: Colors.red,
          label: 'University Location',
          onPressed: () {
            _launchURL(
                'https://www.google.com/maps/place/University+of+Jordan/@32.0161048,35.8695456,15z/data=!4m6!3m5!1s0x151c9f765ba05b27:0x5a5ba049c504b635!8m2!3d32.0161048!4d35.8695456!16zL20vMDdxc2Q1?entry=ttu');
          },
        ),
        CustomButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Schools',
          onPressed: () {
            _showGridModalBottomSheet(
                context, 'University Schools', university.schools);
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
