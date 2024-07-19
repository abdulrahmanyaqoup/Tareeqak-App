import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/Models/user.dart';
import 'package:finalproject/Screens/components/profile/pages/viewProfile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/env/env.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditProfile extends ConsumerStatefulWidget {
  final VoidCallback onSignOut;
  const EditProfile({super.key, required this.onSignOut});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController universityController;
  late TextEditingController majorController;
  late TextEditingController contactController;
  FileImage? _image;
  bool circular = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    universityController.dispose();
    majorController.dispose();
    contactController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, maxWidth: 600);

    setState(() {
      if (pickedFile != null) {
        _image = FileImage(File(pickedFile.path));
      }
    });
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(userProvider).user;
    final updatedUserProps = user.userProps.copyWith(
      university: universityController.text,
      major: majorController.text,
      contact: contactController.text,
      image: _image?.file.path ?? '',
    );
    final updatedUser = user.copyWith(
      name: nameController.text,
      email: emailController.text,
      userProps: updatedUserProps,
    );
    try {
      await ref.read(userProvider.notifier).updateUser(updatedUser);
      if (mounted) {
        showSnackBar(context, 'User updated successfully');
      }
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!);
    }
  }

  Future<void> deleteUser() async {
    try {
      await ref.read(userProvider.notifier).deleteUser();
      if (mounted && !ref.read(userProvider).isLoggedIn) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => viewProfile(onSignOut: widget.onSignOut),
        ));
        showSnackBar(context, 'User deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, e.toString());
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete your account? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).user;
    final double height = MediaQuery.of(context).size.height;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    universityController =
        TextEditingController(text: user.userProps.university);
    majorController = TextEditingController(text: user.userProps.major);
    contactController = TextEditingController(text: user.userProps.contact);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: updateUser,
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
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
          ),
          Positioned(
            top: height * 0.1 - 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(.7),
                        width: 1.0,
                      ),
                    ),
                    child: imageProfile(user)),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          prefixIcon: const Icon(CupertinoIcons.person),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: universityController,
                          hintText: 'University',
                          obscureText: false,
                          prefixIcon: const Icon(Icons.school_outlined),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: majorController,
                          hintText: 'Major',
                          obscureText: false,
                          prefixIcon: const Icon(CupertinoIcons.pencil),
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: contactController,
                          hintText: 'Contact',
                          obscureText: false,
                          prefixIcon: const Icon(CupertinoIcons.phone),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ElevatedButton(
                onPressed: () => _showDeleteConfirmationDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget imageProfile(User user) {
    return Center(
      child: Stack(
        children: [
          ClipOval(
            child: _image == null
                ? CachedNetworkImage(
                    imageUrl: "${Env.URI}${user.userProps.image}",
                    httpHeaders: {'x-api-key': Env.API_KEY},
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 130.0,
                    height: 130.0,
                  )
                : Image(
                    image: _image!,
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
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => bottomSheet(),
                  );
                },
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

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  _pickImage(ImageSource.camera);
                },
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
