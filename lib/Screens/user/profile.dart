import 'dart:io';
import 'package:finalproject/Models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController universityController;
  late TextEditingController majorController;
  late TextEditingController contactController;
  File? _image;
  bool circular = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).user;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    universityController =
        TextEditingController(text: user.userProps.university);
    majorController = TextEditingController(text: user.userProps.major);
    contactController = TextEditingController(text: user.userProps.contact);
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
        _image = File(pickedFile.path);
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
      image: _image?.path,
    );
    final updatedUser = user.copyWith(
      name: nameController.text,
      email: emailController.text,
      userProps: updatedUserProps,
    );

    ref.read(userProvider.notifier).setUserFromModel(updatedUser);

    AuthService().updateUser(
      context: context,
      ref: ref,
      userId: user.id,
      userToken: user.token,
      updates: updatedUser.toMap(),
      token: user.token,
      image: _image,
    );

    setState(() {
      circular = false;
    });
  }

  void signOutUser(BuildContext context, WidgetRef ref) {
    AuthService().signOut(context, ref);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => signOutUser(context, ref),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          children: [
            imageProfile(user),
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
                      width: 100,
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
                  onTap: () => signOutUser(context, ref),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Sign Out",
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
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _image == null
                ? CachedNetworkImageProvider(
                    "${dotenv.env['uri']}/${user.userProps.image}")
                : FileImage(_image!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (builder) => bottomSheet(),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).primaryColor,
                  size: 28.0,
                )),
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
