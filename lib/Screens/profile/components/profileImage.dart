import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../Models/User/user.dart';
import '../../../env/env.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    required this.user,
    required this.image,
    required this.onImagePick,
    super.key,
  });

  final User user;
  final FileImage? image;
  final Future<void> Function() onImagePick;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white12,
            backgroundImage: image ??
                (user.userProps.image.isNotEmpty
                    ? CachedNetworkImageProvider(
                        '${Env.URI}${user.userProps.image}',
                        headers: {'x-api-key': Env.API_KEY},
                        maxWidth: 130,
                        maxHeight: 130,
                        cacheManager:
                            CachedNetworkImageProvider.defaultCacheManager,
                      )
                    : null),
            child: image == null && user.userProps.image.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 60,
                    color: Colors.white,
                  )
                : null,
          ),
        ),
        Positioned(
          bottom: -4,
          right: -4,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: onImagePick,
            elevation: 0,
            highlightElevation: 0,
            mini: true,
            shape: const CircleBorder(),
            child: Icon(
              CupertinoIcons.camera_circle_fill,
              size: 40,
              color: Colors.grey.shade200,
            ),
          ),
        ),
      ],
    );
  }
}
