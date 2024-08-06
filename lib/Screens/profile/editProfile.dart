import 'dart:io';
import 'package:dio/dio.dart';
import 'package:finalproject/Models/University/major.dart';
import 'package:finalproject/Models/University/school.dart';
import 'package:finalproject/Provider/universityProvider.dart';
import 'package:finalproject/Provider/userProvider.dart';
import 'package:finalproject/Screens/profile/profileScreen.dart';
import 'package:finalproject/Utils/utils.dart';
import 'package:finalproject/Widgets/dropdown.dart';
import 'package:finalproject/Widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../../Widgets/customButton.dart';
import 'components/gradientBackground.dart';
import 'components/profileImage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({super.key});

  @override
  EditProfileState createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController contactController;
  FileImage? _image;
  String? _selectedUniversity;
  String? _selectedSchool;
  String? _selectedMajor;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).user;
    nameController = TextEditingController(text: user.name);
    contactController = TextEditingController(text: user.userProps.contact);
    _selectedUniversity = user.userProps.university;
    _selectedSchool = user.userProps.school;
    _selectedMajor = user.userProps.major;
  }

  @override
  void dispose() {
    nameController.dispose();
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

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;

    final user = ref.read(userProvider).user;
    final updatedUserProps = user.userProps.copyWith(
      university: _selectedUniversity,
      school: _selectedSchool,
      major: _selectedMajor,
      contact: contactController.text,
      image: _image?.file.path ?? '',
    );
    final updatedUser = user.copyWith(
      name: nameController.text,
      userProps: updatedUserProps,
    );
    try {
      await ref.read(userProvider.notifier).updateUser(updatedUser);
      if (mounted) {
        showSnackBar(context, 'Profile updated successfully', ContentType.success);
      }
    } on DioException catch (e) {
      if (mounted) showSnackBar(context, e.message!, ContentType.failure);
    }
  }

  Future<void> _signOut() async {
    try {
      await ref.read(userProvider.notifier).signOut();
    } catch (e) {
      if (mounted) showSnackBar(context, e.toString(), ContentType.failure);
    }
    if (!ref.read(userProvider).isLoggedIn && mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (_) => const ProfileScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<void> _deleteUser() async {
    try {
      String response = await ref.read(userProvider.notifier).deleteUser();
      if (mounted && !ref.read(userProvider).isLoggedIn) {
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (_) => const ProfileScreen(),
            ),
            (Route<dynamic> route) => false);
        showSnackBar(context, response, ContentType.success);
      }
    } on DioException catch (e) {
      if (mounted) {
        showSnackBar(context, e.message!, ContentType.failure);
      }
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
              'Are you sure you want to delete your account? This action is irreversible.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUser();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final universityState = ref.watch(universityProvider);
    List<School> schools = [];
    List<Major> majors = [];

    if (_selectedUniversity != null &&
        universityState.universities.isNotEmpty) {
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
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
            iconSize: 18,
          ),
        ],
      ),
      body: GradientBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                ProfileImage(
                  user: ref.read(userProvider).user,
                  image: _image,
                  onImagePick: _pickImage,
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                      CustomTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        prefixIcon: const Icon(CupertinoIcons.person),
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
                            _selectedMajor = null;
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
                          });
                        },
                        enabled: _selectedUniversity != null &&
                            _selectedUniversity!.isNotEmpty,
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
                        enabled: _selectedSchool != null &&
                            _selectedSchool!.isNotEmpty,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        controller: contactController,
                        hintText: 'Contact',
                        obscureText: false,
                        prefixIcon: const Icon(CupertinoIcons.phone),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              onPressed: updateUser,
                              text: 'Update',
                              color: Theme.of(context).colorScheme.primary,
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 1,
                            child: CustomButton(
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(context),
                              text: 'Delete',
                              color: Colors.grey[200]!,
                              textColor: const Color.fromARGB(255, 240, 81, 70),
                            ),
                          ),
                        ],
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
