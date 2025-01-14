import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/models.dart';
import '../../provider/universityProvider.dart';
import '../../provider/userProvider.dart';
import '../../utils/imagePicker.dart';
import '../../widgets/customButton.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/snackBar.dart';
import '../../widgets/textfield.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'verifyScreen.dart';

@immutable
class RegDetailsScreen extends ConsumerStatefulWidget {
  const RegDetailsScreen({
    required this.email,
    required this.password,
    required this.name,
    super.key,
  });

  final String email;
  final String password;
  final String name;

  @override
  ConsumerState<RegDetailsScreen> createState() => _RegDetailsScreen();
}

class _RegDetailsScreen extends ConsumerState<RegDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contactController = TextEditingController();
  File? _image;
  String _selectedUniversity = '';
  String _selectedSchool = '';
  String _selectedMajor = '';
  bool? _enabledSchool = false;
  bool? _enabledMajor = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final user = User(
      name: widget.name,
      email: widget.email,
      userProps: UserProps(
        university: _selectedUniversity,
        school: _selectedSchool,
        major: _selectedMajor,
        contact: _contactController.text.replaceAll(
          RegExp(r'\s+'),
          '',
        ),
        image: _image?.path ?? '',
      ),
    );
    await ref
        .read(userProvider.notifier)
        .register(user, widget.password)
        .then(
          (response) => {
            if (mounted)
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute<void>(
                  builder: (_) =>
                      VerifyScreen(email: widget.email, isRegister: true),
                ),
                (Route<dynamic> route) => route.isFirst,
              ),
            showSnackBar(response, ContentType.success),
            setState(() => _isLoading = false),
          },
        )
        .catchError(
          (Object error) => {
            showSnackBar(error.toString(), ContentType.failure),
            setState(() => _isLoading = false),
            throw Error(),
          },
        );
  }

  Future<void> _pickImage() async {
    final image = await imagePicker();
    if (image == null) return;
    setState(() {
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final universityState = ref.watch(universityProvider);
    var schools = <School>[];
    var majors = <Major>[];
    if (_selectedUniversity.isNotEmpty &&
        universityState.requireValue.universities.isNotEmpty) {
      final selectedUniversity =
          universityState.requireValue.universities.firstWhere(
        (university) => university.name == _selectedUniversity,
        orElse: () => universityState.requireValue.universities.first,
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
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
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
                  'Register Details',
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
                        prefixIcon: Icons.account_balance_outlined,
                        items: universityState.requireValue.universities
                            .map((university) => university.name)
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUniversity = value ?? '';
                            _selectedSchool = '';
                            _selectedMajor = '';
                            if (_selectedUniversity.isNotEmpty) {
                              _enabledSchool = true;
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Dropdown(
                        value: _selectedSchool,
                        hintText: 'Select your school',
                        prefixIcon: CupertinoIcons.book,
                        items: schools.map((school) => school.name).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedSchool = value ?? '';
                            _selectedMajor = '';
                            if (_selectedSchool.isNotEmpty) {
                              _enabledMajor = true;
                            }
                          });
                        },
                        enabled: _enabledSchool,
                      ),
                      const SizedBox(height: 20),
                      Dropdown(
                        value: _selectedMajor,
                        hintText: 'Select your major',
                        prefixIcon: CupertinoIcons.pen,
                        items: majors.map((major) => major.name).toList(),
                        onChanged: (String? value) {
                          setState(() => _selectedMajor = value ?? '');
                        },
                        enabled: _enabledMajor,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        autoFillHints: const [
                          AutofillHints.telephoneNumber,
                          AutofillHints.telephoneNumberNational,
                        ],
                        controller: _contactController,
                        hintText: 'Enter your phone number',
                        prefixIcon: const Icon(CupertinoIcons.phone),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Phone number can't be empty!";
                          } else if (!RegExp(r'^07[789]\d{7}$').hasMatch(
                            value.replaceAll(
                              RegExp(r'\s+'),
                              '',
                            ),
                          )) {
                            return 'Enter a valid phone number! 079*******';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        isLoading: _isLoading,
                        onPressed: _register,
                        text: 'Register',
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
