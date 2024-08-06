import 'dart:io';

import 'package:dio/dio.dart';
import 'package:finalproject/Models/University/major.dart';
import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Provider/universityProvider.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Widgets/customButton.dart';
import 'package:finalproject/Screens/profile/components/formContainer.dart';
import 'package:finalproject/Screens/profile/components/gradientBackground.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Widgets/dropdown.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'otp.dart';

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
  final TextEditingController contactController = TextEditingController();
  File? _image;
  String? _selectedUniversity;
  String? _selectedSchool;
  String? _selectedMajor;
  bool? enabledSchool = false;
  bool? enabledMajor = false;

  @override
  void dispose() {
    contactController.dispose();
    super.dispose();
  }

  Future<void> _signupUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        String response = await ref.read(userProvider.notifier).signUp(
              widget.name,
              widget.email,
              widget.password,
              _selectedUniversity ?? '',
              _selectedSchool ?? '',
              _selectedMajor ?? '',
              contactController.text,
              _image,
            );
        if (mounted) {
          showSnackBar(context, response);
          Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => Otp(email: widget.email),
            ),
            (Route<dynamic> route) => route.isFirst,
          );
        }
      } on DioException catch (e) {
        if (mounted) {
          showSnackBar(context, e.message!);
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
  Widget build(BuildContext context) {
    final universityState = ref.watch(universityProvider);
    List<School> schools = [];
    List<Major> majors = [];
    if (_selectedUniversity != null && universityState.universities.isNotEmpty) {
      var selectedUniversity = universityState.universities.firstWhere(
        (university) => university.name == _selectedUniversity,
        orElse: () => universityState.universities.first,
      );
      schools = selectedUniversity.schools;
      if (_selectedSchool != null && selectedUniversity.schools.isNotEmpty) {
        var selectedSchool = selectedUniversity.schools.firstWhere(
          (school) => school.name == _selectedSchool,
          orElse: () => selectedUniversity.schools.first,
        );
        majors = selectedSchool.majors;
      }
    }

    return Scaffold(
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                const CustomBackButton(),
                const SizedBox(height: 80),
                const HeaderText(text: "Signup"),
                const SizedBox(height: 20),
                FormContainer(
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
                      Dropdown(
                        value: _selectedUniversity,
                        hintText: 'Select your university',
                        prefixIcon: Icons.business,
                        items: universityState.universities
                            .map((university) => university.name)
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUniversity = value ?? '';
                            _selectedSchool = null;
                            _selectedMajor = null ;
                            if (_selectedUniversity != null) {
                              enabledSchool = true;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Dropdown(
                        value: _selectedSchool,
                        hintText: 'Select your school',
                        prefixIcon: Icons.school,
                        items: schools.map((school) => school.name).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSchool = value ?? '';
                            _selectedMajor = null;
                            if (_selectedSchool != null ) {
                              enabledMajor = true;
                            }
                          });
                        },
                        enabled: enabledSchool,
                      ),
                      const SizedBox(height: 20),
                      Dropdown(
                        value: _selectedMajor,
                        hintText: 'Select your major',
                        prefixIcon: CupertinoIcons.pen,
                        items: majors.map((major) => major.name).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedMajor = value ?? '';
                          });
                        },
                        enabled: enabledMajor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: contactController,
                        hintText: 'Enter your contact',
                        prefixIcon: const Icon(CupertinoIcons.phone),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact can\'t be empty!';
                          } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                            return 'Enter a valid contact number!';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onPressed: _signupUser,
                        text: 'Sign up',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
