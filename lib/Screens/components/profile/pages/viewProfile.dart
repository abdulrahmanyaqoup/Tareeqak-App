import 'package:dio/dio.dart';
import 'package:finalproject/Screens/components/profile/pages/editProfile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

class viewProfile extends ConsumerStatefulWidget {
  final VoidCallback onSignOut;
  const viewProfile({super.key, required this.onSignOut});

  @override
  _viewProfileState createState() => _viewProfileState();
}

class _viewProfileState extends ConsumerState<viewProfile> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatue();
  }

  Future<void> _checkLoginStatue() async {
    try {
      await ref.read(userProvider.notifier).checkLoginStatus();
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!);
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
              color: Theme.of(context).colorScheme.surface,
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
                    child: Lottie.asset(
                      'assets/animations/logo.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                            builder: (_) => EditProfile(
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
                        Container(
                          width: 75,
                          height: 75,
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(.7),
                              width: 1.0,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: userState
                                    .user.userProps.image.isNotEmpty
                                ? CachedNetworkImageProvider(
                                    "${Env.URI}${userState.user.userProps.image}",
                                    headers: {'x-api-key': Env.API_KEY})
                                : null,
                            child: userState.user.userProps.image.isEmpty
                                ? const Icon(Icons.person, size: 30)
                                : null,
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.2),
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
                              userState.user.userProps.university.isEmpty
                                  ? '-'
                                  : userState.user.userProps.university,
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
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(.2),
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
                              userState.user.userProps.major.isEmpty
                                  ? '-'
                                  : userState.user.userProps.major,
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
