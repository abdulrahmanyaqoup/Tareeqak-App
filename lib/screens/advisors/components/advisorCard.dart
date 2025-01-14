import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../env/env.dart';
import '../../../model/models.dart';
import '../../../widgets/infoRow.dart';
import 'customIconButton.dart';

@immutable
class AdvisorCard extends StatefulWidget {
  const AdvisorCard({required User user, super.key, bool isProfile = false})
      : _user = user,
        _isProfile = isProfile;
  final bool _isProfile;
  final User _user;

  @override
  State<AdvisorCard> createState() => _AdvisorCard();
}

class _AdvisorCard extends State<AdvisorCard> {
  bool error = false;

  Future<void> _launchWhatsApp() async {
    final contact = '+962${widget._user.userProps.contact.substring(1)}';
    final androidUri = Uri.parse('whatsapp://send?phone=$contact&text=hi');
    final iosUri = Uri.parse('https://wa.me/$contact');
    final webUri = Uri.parse(
      'https://api.whatsapp.com/send/?phone=$contact&text=Hello Advisor '
      '${widget._user.name} \nCan you help me with my academic year ?',
    );
    if (Platform.isIOS) {
      if (await canLaunchUrl(iosUri)) {
        await launchUrl(iosUri, mode: LaunchMode.externalNonBrowserApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);
      }
    } else {
      if (await canLaunchUrl(androidUri)) {
        await launchUrl(
          androidUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);
      }
    }
  }

  Future<void> _launchEmail() async {
    final email = Uri.parse(
      'mailto:${widget._user.email}'
      '?subject=Advisor&body=Hello Advisor ${widget._user.name}.\n\n'
      'Hope you are doing well!\n\n'
      'Can you help me with my academic year?\n\nThanks.',
    );
    if (!await launchUrl(email)) {
      throw Exception('Could not launch $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget._isProfile ? 3 : 0,
      shadowColor: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: !widget._isProfile ? Colors.grey.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    radius: 35,
                    backgroundImage: widget._user.userProps.image.isNotEmpty
                        ? CachedNetworkImageProvider(
                            '${Env.URI}${widget._user.userProps.image}',
                            headers: {'apikey': Env.API_KEY},
                            errorListener: (e) => setState(() => error = true),
                          )
                        : null,
                    child: widget._user.userProps.image.isEmpty || error
                        ? const Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget._user.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget._user.userProps.university,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                          fontWeight: FontWeight.bold,
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
              icon: CupertinoIcons.book,
              label: 'School',
              value: widget._user.userProps.school,
            ),
            const SizedBox(height: 10),
            InfoRow(
              icon: CupertinoIcons.pen,
              label: 'Major',
              value: widget._user.userProps.major,
            ),
            const SizedBox(height: 10),
            if (widget._isProfile)
              const SizedBox()
            else
              Row(
                children: [
                  CustomIconButton(
                    icon: FontAwesomeIcons.envelope,
                    color: Theme.of(context).colorScheme.primary,
                    onTap: _launchEmail,
                  ),
                  const SizedBox(width: 10),
                  CustomIconButton(
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
