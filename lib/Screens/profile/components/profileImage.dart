import 'package:cached_network_image/cached_network_image.dart';
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
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: image == null
                ? CachedNetworkImage(
                    imageUrl: '${Env.URI}${user.userProps.image}',
                    httpHeaders: {'x-api-key': Env.API_KEY},
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 130,
                    height: 130,
                  )
                : Image(
                    image: image!,
                    width: 130,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
          ),
          Positioned(
            bottom: 5,
            right: 0,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(60),
              ),
              child: InkWell(
                onTap: onImagePick,
                child: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
