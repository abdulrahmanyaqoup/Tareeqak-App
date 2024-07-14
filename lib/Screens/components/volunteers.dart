import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Models/user.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({super.key});

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends ConsumerState<Volunteers> {
  @override
  void initState() {
    super.initState();
    try {
      ref.read(userProvider.notifier).getAllUsers();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    List<User> users = ref.watch(userProvider).userList;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      appBar: AppBar(
        title: const Text('Contact With Advisors'),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.all(15),
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).appBarTheme.backgroundColor!,
                      Theme.of(context).appBarTheme.backgroundColor!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Opacity(
                      opacity: .6,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: CustomPaint(
                          painter: CustomIconsPainter(),
                          size: const Size(double.infinity, 150),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          'Join ambassadors !\n be a model for other students by helping them in their academic year',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            users.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ProfileCard(
                        user: user,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

class CustomIconsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 56, 53, 63)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    PaintingStyle.fill;
    double x = (size.width / 30) + (size.width / 1000);
    double y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 70, paint);

    x = (size.width / 2) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(const Offset(10, 10), 30, paint);

    x = (size.width / 1.2) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(const Offset(100, 30), 30, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 30, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 70, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(const Offset(350, 0), 50, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key, required this.user});
  final User user;

  Future<void> whatsapp() async {
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

  Future<void> _launchUrl(email) async {
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
                            '${Env.URI}${user.userProps.image}${Env.API_KEY}')
                        : null,
                    child: user.userProps.image.isEmpty
                        ? const Icon(Icons.person, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.school,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'University',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      user.userProps.university.isEmpty
                          ? '-'
                          : user.userProps.university,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    CupertinoIcons.pen,
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Major',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      user.userProps.major.isEmpty ? '-' : user.userProps.major,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    final Uri email = Uri.parse(
                        'mailto:${user.email}?subject=Advisor&body=Hello Advisor ${user.name}.\n\nHope you are doing well!\n\nCan you help me with my academic year?\n\nThanks.');
                    _launchUrl(
                      email,
                    );
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 68, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.envelope,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () => whatsapp(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 68, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
