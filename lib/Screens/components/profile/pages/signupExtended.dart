import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/api/userApi.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/Widgets/dropdown.dart';

class SignupOptionalScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final String name;

  const SignupOptionalScreen({
    super.key,
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  _SignupOptionalScreenState createState() => _SignupOptionalScreenState();
}

class _SignupOptionalScreenState extends ConsumerState<SignupOptionalScreen> {
  final TextEditingController majorController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final UserApi userApi = UserApi();
  File? _image;
  String? _selectedUniversity;

  final List<String> _universities = [
    'University of Jordan',
    'Yarmouk University',
    'Jordan University of Science and Technology',
    'Hashemite University',
    'German Jordanian University',
    'Tafileh Technical University',
    'Al-Balqa Applied University',
    'Al-Hussein Bin Talal University',
    'Al-Hussein Technical University',
  ];

  Future signupUser() async {
    try {
      String response = await userApi.signUp(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        university: _selectedUniversity ?? '',
        major: majorController.text,
        contact: contactController.text,
        image: _image,
      );
      showSnackBar(context, response);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
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

  @override
  void dispose() {
    majorController.dispose();
    contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 60),
            const Text(
              "Signup",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[200],
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(
                        Icons.add_a_photo,
                        size: 40,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomDropdown(
                value: _selectedUniversity,
                hintText: 'Select your university',
                items: _universities,
                onChanged: (String? value) {
                  setState(() {
                    _selectedUniversity = value ?? '';
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: majorController,
                hintText: 'Enter your major',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomTextField(
                controller: contactController,
                hintText: 'Enter your contact',
                obscureText: false,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: signupUser,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                textStyle: WidgetStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: WidgetStateProperty.all(
                  Size(MediaQuery.of(context).size.width / 2.5, 50),
                ),
              ),
              child: const Text(
                "Sign up",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
