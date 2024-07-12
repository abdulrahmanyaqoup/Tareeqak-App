import 'package:finalproject/Screens/profile/components/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finalproject/Services/authService.dart';
import 'package:finalproject/Provider/authProvider.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  final VoidCallback onSignOut;
  const CompleteProfilePage({super.key, required this.onSignOut});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
 
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    ref.read(authProvider.notifier).checkLoginStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: height * 0.25),
            height: height * 0.75,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 150),
                  Container(
                        height: 200,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                        ),
                        child: Image.network(
                          'https://img.freepik.com/free-vector/remote-meeting-concept-illustration_114360-4704.jpg?t=st=1720743352~exp=1720746952~hmac=ae4560815f69c085e9dbb270b373d92233003f60a0eefb2c2e9a2520eccd3e0e&w=1060',
                        ),
                      ),
                  const SizedBox(height: 20),
                  Text(
                    user.token.isNotEmpty
                        ? 'Welcome back!'
                        : 'Be a part of our community!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (user.token.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => Profile(
                              onSignOut: widget.onSignOut,
                            ),
                          ),
                        
                        );
                      } else {
                        Navigator.of(context).pushNamed('/signup');
                      }
                    },
                    child: Text(user.token.isNotEmpty ? 'Go to Profile' : 'Sign Up'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.2 - 60,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: user.userProps.image.isNotEmpty
                              ? CachedNetworkImageProvider(
                                  '${dotenv.env['uri']}/${user.userProps.image}')
                              : null,
                          child: user.userProps.image.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          user.name.isNotEmpty ? user.name : '-',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        
                        Icon(Icons.school,
                            color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'University',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              user.userProps.university.isNotEmpty
                                  ? user.userProps.university
                                  : 'Not Specified',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                       
                        Icon(Icons.edit,
                            color: Theme.of(context).colorScheme.secondary),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Major',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              user.userProps.major.isNotEmpty
                                  ? user.userProps.major
                                  : 'Not Specified',
                              style: TextStyle(
                                fontSize: 14,
                                color:
                                    Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
