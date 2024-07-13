import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Models/user.dart';
import 'package:url_launcher/url_launcher.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({super.key});

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends ConsumerState<Volunteers> {
  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = ref.watch(userProvider);

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
            userState.userList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: userState.userList.length,
                    itemBuilder: (context, index) {
                      final user = userState.userList[index];
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

  void _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
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
        padding: const EdgeInsets.all(16.0),
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
                        ? 
                    CachedNetworkImageProvider(
                        '${Env.URI}${user.userProps.image}?apiKey=${Env.API_KEY}')
                        : null,
                    child: user.userProps.image.isEmpty
                        ? const Icon(Icons.person, size: 30) :
                    null,
                      
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
                  onTap: () => _launchURL('mailto:${user.email}'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.email,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 30),
                InkWell(
                  onTap: () =>
                      _launchURL('https://wa.me/${user.userProps.contact}'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(.2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.primary,
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
