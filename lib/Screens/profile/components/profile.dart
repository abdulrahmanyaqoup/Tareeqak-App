import 'dart:io';
import 'package:finalproject/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/backend/authentication.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends ConsumerStatefulWidget {
  final VoidCallback onSignOut;
  const Profile({super.key, required this.onSignOut});

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends ConsumerState<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController universityController;
  late TextEditingController majorController;
  late TextEditingController contactController;
  FileImage? _image;
  bool circular = false;
  final AuthService authService = AuthService();

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

  void updateUser(BuildContext context, WidgetRef ref) {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      circular = true;
    });

    final user = ref.read(userProvider).user;
    final updatedUserProps = user.userProps.copyWith(
      university: universityController.text,
      major: majorController.text,
      contact: contactController.text,
      image: _image?.file.path,
    );
    final updatedUser = user.copyWith(
      name: nameController.text,
      email: emailController.text,
      userProps: updatedUserProps,
    );

    AuthService().updateUser(
      userId: user.id,
      updates: updatedUser.toMap(),
    );
    setState(() {
      circular = false;
    });
  }

  void deleteUser(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider);
    AuthService().deleteUser(
      context: context,
      ref: ref,
      id: user.user.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    nameController = TextEditingController(text: user.user.name);
    emailController = TextEditingController(text: user.user.email);
    universityController =
        TextEditingController(text: user.user.userProps.university);
    majorController = TextEditingController(text: user.user.userProps.major);
    contactController =
        TextEditingController(text: user.user.userProps.contact);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => widget.onSignOut(),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            imageProfile(user.user),
            const SizedBox(height: 20),
            CustomTextField(
              controller: nameController,
              hintText: 'Name',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: universityController,
              hintText: 'University',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: majorController,
              hintText: 'Major',
              obscureText: false,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: contactController,
              hintText: 'Contact',
              obscureText: false,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => updateUser(context, ref),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: circular
                            ? const CircularProgressIndicator()
                            : const Text(
                                "Update",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => deleteUser(context, ref),
                  child: Center(
                    child: Container(
                      width: 140,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Delete Account",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
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
                      imageUrl:
                          "${dotenv.env['uri'].toString()}/${user.userProps.image}",
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 160.0,
                      height: 160.0,
                    )
                  : Image(
                      image: _image!,
                      width: 160.0,
                      height: 160.0,
                      fit: BoxFit.cover,
                    )),
          Positioned(
            bottom: 10,
            right: 5,
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
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
                  )),
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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
          ])
        ],
      ),
    );
  }
}
