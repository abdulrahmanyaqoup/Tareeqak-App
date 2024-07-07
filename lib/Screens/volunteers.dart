import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Models/user.dart';

class Volunteers extends ConsumerStatefulWidget {
  const Volunteers({Key? key}) : super(key: key);

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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5FE),
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: const Text(
              'Join ambassadors be a model for other students by helping them in their academic year!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0074D9),
              ),
            ),
          ),
          Expanded(
            child: userList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final user = userList[index];
                      return VolunteerCard(user: user);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class VolunteerCard extends StatelessWidget {
  final User user;

  const VolunteerCard({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(user.userProps.image.isNotEmpty
              ? '${dotenv.env['uri']}/${user.userProps.image}'
              : 'https://via.placeholder.com/150'),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.userProps.university),
            Text(user.userProps.major),
            Text(user.userProps.contact),
          ],
        ),
      ),
    );
  }
}
