import 'package:finalproject/Screens/profile/components/editProfile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CompleteProfilePage extends ConsumerStatefulWidget {
  final VoidCallback onSignOut;
  const CompleteProfilePage({super.key, required this.onSignOut});

  @override
  _CompleteProfilePageState createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends ConsumerState<CompleteProfilePage> {
  @override
  void initState() {
    super.initState();
    try {
      ref.read(userProvider.notifier).checkLoginStatus();
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
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
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Image.network(
                      'https://img.freepik.com/free-vector/remote-meeting-concept-illustration_114360-4704.jpg?t=st=1720743352~exp=1720746952~hmac=ae4560815f69c085e9dbb270b373d92233003f60a0eefb2c2e9a2520eccd3e0e&w=1060',
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    userState.isLoggedIn
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
                      if (userState.isLoggedIn) {
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
                    child: Text(
                        userState.isLoggedIn ? 'Go to Profile' : 'Sign Up'),
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
                          backgroundImage:
                              userState.user.userProps.image.isNotEmpty
                                  ? CachedNetworkImageProvider(
                                      userState.user.userProps.image)
                                  : null,
                          child: userState.user.userProps.image.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          userState.user.name.isNotEmpty
                              ? userState.user.name
                              : '-',
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              userState.user.userProps.university.isNotEmpty
                                  ? userState.user.userProps.university
                                  : 'Not Specified',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
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
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              userState.user.userProps.major.isNotEmpty
                                  ? userState.user.userProps.major
                                  : 'Not Specified',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
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
