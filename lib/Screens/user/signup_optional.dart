import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Services/auth_service.dart';
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
  TextEditingController majorController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  final AuthService authService = AuthService();
  File? _image;
  String? _selectedUniversity;

  final List<String> _universities = [
    'Harvard University',
    'Stanford University',
    'MIT',
    'University of California, Berkeley',
    'University of Oxford',
    // Add more universities as needed
  ];

  void signupUser() {
    authService.signUpUser(
      context: context,
      ref: ref, // Ensure ref is properly initialized and not null
      email: widget.email,
      password: widget.password,
      name: widget.name,
      university: _selectedUniversity ?? '',
      major: majorController.text,
      contact: contactController.text,
      image: _image,
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
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
                    _selectedUniversity = value;
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
                backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).primaryColor,
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(color: Colors.white),
                ),
                minimumSize: MaterialStateProperty.all(
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
