import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/Screens/volunteers/components/customButton.dart';
import 'package:finalproject/Screens/volunteers/components/volunteerInfo.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class VolunteerCard extends StatelessWidget {
  const VolunteerCard({super.key, required this.user, this.isProfile = false});
  final bool isProfile;
  final User user;

  Future<void> _launchWhatsApp() async {
    String contact = '+962${user.userProps.contact.substring(1)}';
    Uri androidUri = Uri.parse("whatsapp://send?phone=$contact&text=hi");
    Uri iosUri = Uri.parse("https://wa.me/$contact");
    Uri webUri = Uri.parse(
        'https://api.whatsapp.com/send/?phone=$contact&text=Hello Advisor ${user.name} \nCan you help me with my academic year ?');

    if (Platform.isIOS) {
      if (await canLaunchUrl(iosUri)) {
        await launchUrl(iosUri, mode: LaunchMode.externalNonBrowserApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);
      }
    } else {
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(androidUri,
            mode: LaunchMode.externalNonBrowserApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);
      }
    }
  }

  Future<void> _launchEmail() async {
    final Uri email = Uri.parse(
      'mailto:${user.email}?subject=Advisor&body=Hello Advisor ${user.name}.\n\nHope you are doing well!\n\nCan you help me with my academic year?\n\nThanks.',
    );
    if (!await launchUrl(email)) {
      throw Exception('Could not launch $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.7),
                      width: 1.0,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 35,
                    backgroundImage: user.userProps.image.isNotEmpty
                        ? CachedNetworkImageProvider(
                            '${Env.URI}${user.userProps.image}',
                            headers: {"x-api-key": Env.API_KEY})
                        : null,
                    child: user.userProps.image.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        user.userProps.university,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            InfoRow(
                icon: Icons.school,
                label: 'School',
                value: user.userProps.school),
            const SizedBox(height: 10),
            InfoRow(
                icon: CupertinoIcons.pen,
                label: 'Major',
                value: user.userProps.major),
            const SizedBox(height: 10),
            isProfile ? const SizedBox() : 
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ActionIcon(
                  icon: FontAwesomeIcons.envelope,
                  color: Theme.of(context).colorScheme.primary,
                  onTap: _launchEmail,
                ),
                const SizedBox(width: 10),
                ActionIcon(
                  icon: FontAwesomeIcons.whatsapp,
                  color: Colors.green.withOpacity(0.8),
                  onTap: _launchWhatsApp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
