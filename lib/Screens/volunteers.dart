import 'package:finalproject/backend/authentication.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Models/user.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({super.key});

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends ConsumerState<Volunteers> {
  final authService = AuthService();

  @override
  void initState() {
    super.initState();
    authService.getAllUsers();
    ref.read(userProvider.notifier).getAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    UserState userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact With Avisors'),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(.4),
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
      ..color = const Color(0xFFFDE9CC)
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
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Adjusted border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16), // Adjusted padding
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20), // Adjusted border radius
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context)
                          .colorScheme
                          .primary, // Adjusted color scheme
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.7),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 80, 
                      height: 80, 
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:Theme.of(context)
                              .colorScheme
                              .tertiary.withOpacity(.7), 
                          width: 1.0, 
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                            '${dotenv.env['uri']}/${user.userProps.image}'),
                        child: user.userProps.image.isEmpty
                            ? const Icon(Icons.person,
                                size: 30) 
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      user.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.all(16), // Adjusted padding for uniformity
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.school,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Adjusted icon color
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.userProps.university,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface, // Adjusted text color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.code,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Adjusted icon color
                    ),
                    const SizedBox(width: 5),
                    Text(
                      user.userProps.major,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface, // Adjusted text color
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Adjusted icon color
                    ),
                    const SizedBox(width: 3),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface, // Adjusted text color
                      ),
                    ),
                    const SizedBox(width: 30),
                    Icon(
                      Icons.phone,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary, // Adjusted icon color
                    ),
                    const SizedBox(width: 3),
                    Text(
                      user.userProps.contact,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface, // Adjusted text color
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
