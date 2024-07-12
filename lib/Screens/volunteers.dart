import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Models/user.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({super.key});

  @override
  _VolunteersState createState() => _VolunteersState();
}

class _VolunteersState extends ConsumerState<Volunteers> {
  final AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authService.getAllUsers(context: context, ref: ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userList = ref.watch(userProvider).userList;

    return Scaffold(
      body: Column(
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
                        size: Size(double.infinity, 150),
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
          Expanded(
            child: userList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return ProfileCard(
                        user: user,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CustomIconsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 128, 127, 182)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;
    PaintingStyle.fill;
    double x = (size.width / 30) + (size.width / 1000);
    double y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 70, paint);

    x = (size.width / 2) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(10, 10), 30, paint);

    x = (size.width / 1.2) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(100, 30), 30, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 30, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(x, y), 70, paint);

    x = (size.width / 1.5) + (size.width / 1000);
    y = (size.height / 2) + (70);
    canvas.drawCircle(Offset(350, 0), 50, paint);
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
      margin: const EdgeInsets.all(15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).appBarTheme.backgroundColor!,
                      Theme.of(context)
                          .appBarTheme
                          .backgroundColor!
                          .withOpacity(.7),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          '${dotenv.env['uri']}/${user.userProps.image}'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      Icons.school,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.userProps.university,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.code,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      user.userProps.major,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      'abd0203489@ju.edu.jo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      user.userProps.contact,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
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
