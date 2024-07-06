import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Provider/user_provider.dart';
import 'package:finalproject/Widgets/textfield.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController universityController;
  late TextEditingController majorController;
  late TextEditingController contactController;
  File? _image;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).user;
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    universityController = TextEditingController(text: user.userProps.university);
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  void updateUser(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider).user;
    final updatedUserProps = user.userProps.copyWith(
      university: universityController.text,
      major: majorController.text,
      contact: contactController.text,
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
      updates: updatedUser.toMap(),
      token: user.token,
      imageFile: _image,
    );
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null ? FileImage(_image!) : NetworkImage(user.userProps.image) as ImageProvider,
                child: _image == null ? const Icon(Icons.camera_alt, size: 50) : null,
              ),
            ),
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
            ElevatedButton(
              onPressed: () => updateUser(context, ref),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Update",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => signOutUser(context, ref),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
