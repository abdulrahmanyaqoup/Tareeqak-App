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
            // _showModalBottomSheet(context, 'Major Advisors', major.advisors);
          },
        ),
        UniversityButtons(
          icon: Icons.list_alt,
          iconColor: Colors.blue,
          label: 'Major\nPlan',
          onPressed: () {
            _launchURL(major.roadmap);
          },
        ),
        UniversityButtons(
          icon: Icons.work,
          iconColor: Colors.red,
          label: 'Future\nJobs',
          onPressed: () {
            _showModalBottomSheet(context, 'Future\nJobs', major.jobs);
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

  void _showModalBottomSheet(
      BuildContext context, String title, List<String> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors
          .transparent, 
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        item,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
