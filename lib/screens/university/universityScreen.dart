import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/models.dart';
import '../../provider/userProvider.dart';
import 'components/advisorsSheet.dart';
import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';

@immutable
class UniversityScreen extends ConsumerWidget {
  const UniversityScreen({
    required this.university,
    super.key,
  });

  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAdvisors = ref.watch(userProvider);
    final universityAdvisors = allAdvisors.value!.userList
        .where((user) => user.userProps.university == university.name)
        .toList();

    return DetailBase(
      title: university.name,
      logo: university.logo,
      description: university.description,
      city: university.city,
      universityType: university.type,
      facts: university.facts,
      buttons: [
        CustomButtons(
          icon: Icons.people,
          iconColor: Colors.green,
          label: 'University Advisors',
          onPressed: () {
            _showAdvisors(
              context,
              'University Advisors',
              universityAdvisors,
            );
          },
        ),
        CustomButtons(
          icon: Icons.location_on,
          iconColor: Colors.red,
          label: 'University Location',
          onPressed: () {
            _launchURL(
              university.location,
            );
          },
        ),
        CustomButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Schools',
          onPressed: () {
            _showGridModalBottomSheet(
              context,
              'University Schools',
              university.schools,
              universityAdvisors,
              university.website,
            );
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
    String? universityWebsite,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return GridModalBottomSheet(
          title: title,
          items: items,
          universityAdvisors: advisors,
          universityWebsite: universityWebsite,
        );
      },
    );
  }
}
