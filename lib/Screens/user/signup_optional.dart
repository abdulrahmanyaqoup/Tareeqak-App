import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/Services/auth_service.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class SignupOptionalScreen extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final String name;

  const SignupOptionalScreen({
    Key? key,
    required this.email,
    required this.password,
    required this.name,
  }) : super(key: key);

  @override
  _SignupOptionalScreenState createState() => _SignupOptionalScreenState();
}

class _SignupOptionalScreenState extends ConsumerState<SignupOptionalScreen> {
  final TextEditingController majorController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
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
      ref: ref,
      email: widget.email,
      password: widget.password,
      name: widget.name,
      university: _selectedUniversity,
      major: majorController.text,
      contact: contactController.text,
      imageFile: _image,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            const Text(
              "Signup - Optional Fields",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  hint: const Text('Select your university'),
                  value: _selectedUniversity,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedUniversity = newValue;
                    });
                  },
                  items: _universities.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Select Profile Image'),
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
