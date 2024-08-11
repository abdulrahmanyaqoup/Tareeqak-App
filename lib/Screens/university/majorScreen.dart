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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      context: context,
      builder: (BuildContext bc) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                ),
                itemBuilder: (context, int index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        item[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
