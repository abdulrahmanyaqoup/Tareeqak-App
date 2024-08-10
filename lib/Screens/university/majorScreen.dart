import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/University/major.dart';
import '../../Models/User/user.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';
import 'components/volunteersSheet.dart';

class MajorScreen extends StatelessWidget {
  const MajorScreen({
    required this.major,
    super.key,
    this.schoolVolunteers,
    this.universityWebsite,
  });
  final Major major;
  final List<User>? schoolVolunteers;
  final String? universityWebsite;

  @override
  Widget build(BuildContext context) {
    final majorVolunteers = schoolVolunteers!
        .where((user) => user.userProps.major == major.name)
        .toList();

    return DetailBase(
      title: major.name,
      description: major.description,
      facts: major.facts,
      buttons: [
        CustomButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'Major Advisors',
          onPressed: () {
            _showVolunteers(context, 'Major Advisors', majorVolunteers);
          },
        ),
        CustomButtons(
          icon: Icons.list_alt,
          iconColor: Colors.blue,
          label: 'Major\nPlan',
          onPressed: () {
            final url =
                (major.roadmap.isEmpty) ? universityWebsite : major.roadmap;
            if (url != null && url.isNotEmpty) {
              _launchURL(url);
            }
          },
        ),
        CustomButtons(
          icon: Icons.work,
          iconColor: Colors.red,
          label: 'Future\nJobs',
          onPressed: () {
            _showModalBottomSheet(context, 'Future Jobs', major.jobs);
          },
        ),
      ],
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
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

  void _showModalBottomSheet(
    BuildContext context,
    String title,
    List<String> items,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
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
