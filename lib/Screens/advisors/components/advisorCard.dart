import 'dart:io';import 'package:cached_network_image/cached_network_image.dart';import 'package:flutter/cupertino.dart';import 'package:flutter/material.dart';import 'package:font_awesome_flutter/font_awesome_flutter.dart';import 'package:url_launcher/url_launcher.dart';import '../../../env/env.dart';import '../../../model/models.dart';import '../../../widgets/infoRow.dart';import 'customIconButton.dart';class AdvisorCard extends StatelessWidget {  const AdvisorCard({required User user, super.key, bool isProfile = false})      : _user = user,        _isProfile = isProfile;  final bool _isProfile;  final User _user;  Future<void> _launchWhatsApp() async {    final contact = '+962${_user.userProps.contact.substring(1)}';    final androidUri = Uri.parse('whatsapp://send?phone=$contact&text=hi');    final iosUri = Uri.parse('https://wa.me/$contact');    final webUri = Uri.parse(      'https://api.whatsapp.com/send/?phone=$contact&text=Hello Advisor ${_user.name} \nCan you help me with my academic year ?',    );    if (Platform.isIOS) {      if (await canLaunchUrl(iosUri)) {        await launchUrl(iosUri, mode: LaunchMode.externalNonBrowserApplication);      } else {        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);      }    } else {      if (await canLaunchUrl(androidUri)) {        await launchUrl(          androidUri,          mode: LaunchMode.externalNonBrowserApplication,        );      } else {        await launchUrl(webUri, mode: LaunchMode.externalNonBrowserApplication);      }    }  }  Future<void> _launchEmail() async {    final email = Uri.parse(      'mailto:${_user.email}'      '?subject=Advisor&body=Hello Advisor ${_user.name}.\n\n'      'Hope you are doing well!\n\n'      'Can you help me with my academic year?\n\nThanks.',    );    if (!await launchUrl(email)) {      throw Exception('Could not launch $email');    }  }  @override  Widget build(BuildContext context) {    return Card(      elevation: _isProfile ? 1 : 0,      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),      color: !_isProfile ? Colors.grey.shade100 : Colors.white,      shape: RoundedRectangleBorder(        borderRadius: BorderRadius.circular(10),      ),      child: Padding(        padding: const EdgeInsets.all(14),        child: Column(          crossAxisAlignment: CrossAxisAlignment.start,          children: [            Row(              children: [                Container(                  width: 75,                  height: 75,                  padding: const EdgeInsets.all(4),                  decoration: BoxDecoration(                    shape: BoxShape.circle,                    border: Border.all(                      color: Colors.grey.shade600,                    ),                  ),                  child: CircleAvatar(                    backgroundColor: Theme.of(context).colorScheme.primary,                    radius: 35,                    backgroundImage: _user.userProps.image.isNotEmpty                        ? CachedNetworkImageProvider(                            '${Env.URI}${_user.userProps.image}',                            headers: {'x-api-key': Env.API_KEY},                          )                        : null,                    child: _user.userProps.image.isEmpty                        ? const Icon(                            Icons.person,                            size: 30,                            color: Colors.white,                          )                        : null,                  ),                ),                const SizedBox(width: 10),                Expanded(                  child: Column(                    crossAxisAlignment: CrossAxisAlignment.start,                    children: [                      Text(                        _user.name,                        style: TextStyle(                          fontWeight: FontWeight.bold,                          color: Theme.of(context).colorScheme.primary,                          fontSize: 16,                        ),                      ),                      Text(                        _user.userProps.university,                        style: TextStyle(                          color: Theme.of(context)                              .colorScheme                              .onSurface                              .withOpacity(0.7),                          fontWeight: FontWeight.bold,                          fontSize: 14,                        ),                      ),                    ],                  ),                ),              ],            ),            const SizedBox(height: 20),            InfoRow(              icon: Icons.school,              label: 'School',              value: _user.userProps.school,            ),            const SizedBox(height: 10),            InfoRow(              icon: CupertinoIcons.pen,              label: 'Major',              value: _user.userProps.major,            ),            const SizedBox(height: 10),            if (_isProfile)              const SizedBox()            else              Row(                children: [                  CustomIconButton(                    icon: FontAwesomeIcons.envelope,                    color: Theme.of(context).colorScheme.primary,                    onTap: _launchEmail,                  ),                  const SizedBox(width: 10),                  CustomIconButton(                    icon: FontAwesomeIcons.whatsapp,                    color: Colors.green.withOpacity(0.8),                    onTap: _launchWhatsApp,                  ),                ],              ),          ],        ),      ),    );  }}