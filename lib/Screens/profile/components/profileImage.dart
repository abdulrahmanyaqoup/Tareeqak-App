import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalproject/Models/User/user.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatelessWidget {
  final User user;
  final FileImage? image;
  final Function(ImageSource) onImagePick;

  const ProfileImage({
    super.key,
    required this.user,
    required this.image,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: image == null
                ? CachedNetworkImage(
                    imageUrl: "${Env.URI}${user.userProps.image}",
                    httpHeaders: {'x-api-key': Env.API_KEY},
                    placeholder: (context, url) => const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 130.0,
                    height: 130.0,
                  )
                : Image(
                    image: image!,
                    width: 130.0,
                    height: 130.0,
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
                onTap: () => _showBottomSheet(context),
                child: Icon(
                  Icons.photo_camera,
                  color: Theme.of(context).primaryColor,
                  size: 28.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) => _bottomSheet(context),
    );
  }

  Widget _bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: () => onImagePick(ImageSource.camera),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => onImagePick(ImageSource.gallery),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
