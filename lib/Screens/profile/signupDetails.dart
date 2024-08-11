import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/models.dart';
import '../../provider/universityProvider.dart';
import '../../provider/userProvider.dart';
import '../../widgets/customButton.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/snackBar.dart';
import '../../widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'otp.dart';

class SignupDetails extends ConsumerStatefulWidget {
  const SignupDetails({
    required this.email,
    required this.password,
    required this.name,
    super.key,
  });

  final String email;
  final String password;
  final String name;

  @override
  ConsumerState<SignupDetails> createState() => _SignupDetails();
}

class _SignupDetails extends ConsumerState<SignupDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController contactController = TextEditingController();
  FileImage? _image;
  String _selectedUniversity = '';
  String _selectedSchool = '';
  String _selectedMajor = '';
  bool? enabledSchool = false;
  bool? enabledMajor = false;
  bool isLoading = false;

  @override
  void dispose() {
    contactController.dispose();
    super.dispose();
  }

  Future<void> _signupUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });

    final user = User(
      name: widget.name,
      email: widget.email,
      userProps: UserProps(
        university: _selectedUniversity,
        school: _selectedSchool,
        major: _selectedMajor,
        contact: contactController.text,
        image: _image?.file.path ?? '',
      ),
    );
    await ref.read(userProvider.notifier).signUp(user, widget.password).then(
      (response) {
        if (_image != null) _image = null;
        Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute<void>(
            builder: (_) => Otp(email: widget.email),
          ),
          (Route<dynamic> route) => route.isFirst,
        );
        showSnackBar(context, response, ContentType.success);
      },
    ).catchError(
      (Object error) {
        showSnackBar(context, error.toString(), ContentType.failure);
        setState(() {
          isLoading = false;
        });
        throw Error();
      },
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickedFile != null) {
        _image = FileImage(File(pickedFile.path));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final universityState = ref.watch(universityProvider);
    var schools = <School>[];
    var majors = <Major>[];
    if (_selectedUniversity.isNotEmpty &&
        universityState.valueOrNull!.universities.isNotEmpty) {
      final selectedUniversity =
          universityState.valueOrNull!.universities.firstWhere(
        (university) => university.name == _selectedUniversity,
        orElse: () => universityState.valueOrNull!.universities.first,
      );
      schools = selectedUniversity.schools;
      if (_selectedSchool.isNotEmpty && selectedUniversity.schools.isNotEmpty) {
        final selectedSchool = selectedUniversity.schools.firstWhere(
          (school) => school.name == _selectedSchool,
          orElse: () => selectedUniversity.schools.first,
        );
        majors = selectedSchool.majors;
      }
    }

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.arrow_left, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        border: null,
      ),
      body: RoundedBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Signup',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          backgroundImage: _image,
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
                        items: universityState.valueOrNull!.universities
                            .map((university) => university.name)
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUniversity = value ?? '';
                            _selectedSchool = '';
                            _selectedMajor = '';
                            if (_selectedUniversity.isNotEmpty) {
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
                            _selectedMajor = '';
                            if (_selectedSchool.isNotEmpty) {
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
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Contact can't be empty!";
                          } else if (RegExp(r'^07[789]\d{7}$')
                              .hasMatch(value)) {
                            return 'Enter a valid contact number!';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        isLoading: isLoading,
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
