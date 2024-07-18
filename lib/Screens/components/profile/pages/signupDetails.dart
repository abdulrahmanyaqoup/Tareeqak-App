import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/components/profile/pages/viewProfile.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finalproject/api/userApi.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:finalproject/Widgets/dropdown.dart';

class SignupDetails extends ConsumerStatefulWidget {
  final String email;
  final String password;
  final String name;

  const SignupDetails({
    super.key,
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  _SignupDetails createState() => _SignupDetails();
}

class _SignupDetails extends ConsumerState<SignupDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController majorController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
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

  Future<void> signupUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref.read(userProvider.notifier).signUp(
              widget.name,
              widget.email,
              widget.password,
              _selectedUniversity ?? '',
              majorController.text,
              contactController.text,
              _image,
            );
        if (mounted) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => viewProfile(
              onSignOut: () {},
            ),
          ));
          showSnackBar(context, 'Your account has been created successfully');
        }
      } catch (e) {
        if (mounted) {
          showSnackBar(context, e.toString());
        }
      }
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
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white.withOpacity(0.8),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(height: 80),
                  const Text(
                    "Signup",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[200],
                            backgroundImage:
                                _image != null ? FileImage(_image!) : null,
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
                        CustomDropdown(
                          value: _selectedUniversity,
                          hintText: 'Select your university',
                          items: _universities,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedUniversity = value ?? '';
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: majorController,
                          hintText: 'Enter your major',
                          validator: (value) =>
                              value!.isEmpty ? 'Major can\'t be empty!' : null,
                          obscureText: false,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: contactController,
                          hintText: 'Enter your contact',
                          validator: (value) => value!.isEmpty
                              ? 'Contact can\'t be empty!'
                              : null,
                          obscureText: false,
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: signupUser,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.primary),
                            minimumSize: MaterialStateProperty.all(
                                const Size(double.infinity, 50)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
