import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Models/University/university.dart';
import '../../Models/User/user.dart';
import '../../Provider/userProvider.dart';
import 'components/bottomSheet.dart';
import 'components/customButtons.dart';
import 'components/detailBase.dart';
import 'components/volunteersSheet.dart';

class UniversityScreen extends ConsumerWidget {

  const UniversityScreen({
    required this.university, super.key,
  });
  final University university;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVolunteers = ref.watch(userProvider);
    final universityVolunteers = allVolunteers.value!.userList
        .where((user) => user.userProps.university == university.name)
        .toList();

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
            _showVolunteers(
                context, 'University Advisors', universityVolunteers,);
          },
        ),
        CustomButtons(
          icon: Icons.location_on,
          iconColor: Colors.red,
          label: 'University Location',
          onPressed: () {
            _launchURL(
                'https://www.google.com/maps/place/University+of+Jordan/@32.0161048,35.8695456,15z/data=!4m6!3m5!1s0x151c9f765ba05b27:0x5a5ba049c504b635!8m2!3d32.0161048!4d35.8695456!16zL20vMDdxc2Q1?entry=ttu',);
          },
        ),
        CustomButtons(
          icon: Icons.school,
          iconColor: Colors.orange,
          label: 'University Schools',
          onPressed: () {
            _showGridModalBottomSheet(context, 'University Schools',
                university.schools, universityVolunteers,);
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
      BuildContext context, String title, List<User> volunteers,) {
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

  void _showGridModalBottomSheet(BuildContext context, String title,
      List<dynamic> items, List<User> volunteers,) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return GridModalBottomSheet(
          title: title,
          items: items,
          universityVolunteers: volunteers,
        );
      },
    );
  }
}
