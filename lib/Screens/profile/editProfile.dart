import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../Models/University/major.dart';
import '../../Models/University/school.dart';
import '../../Models/User/user.dart';
import '../../Models/User/userProps.dart';
import '../../Provider/universityProvider.dart';
import '../../Provider/userProvider.dart';
import '../../Widgets/customButton.dart';
import '../../Widgets/dropdown.dart';
import '../../Widgets/snackBar.dart';
import '../../Widgets/textfield.dart';
import 'components/profileImage.dart';
import 'components/roundedBackground.dart';
import 'profileScreen.dart';

class EditProfile extends ConsumerStatefulWidget {
  const EditProfile({required this.user, super.key});

  final User user;

  @override
  ConsumerState<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends ConsumerState<EditProfile>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController contactController;
  FileImage? _image;
  String _selectedUniversity = '';
  String _selectedSchool = '';
  String _selectedMajor = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
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

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
    });
    final updatedUserProps = UserProps(
      university: _selectedUniversity,
      school: _selectedSchool,
      major: _selectedMajor,
      contact: contactController.text,
      image: _image?.file.path ?? '',
    );
    final updatedUser = User(
      email: widget.user.email,
      name: nameController.text,
      userProps: updatedUserProps,
    );
    await ref
        .read(userProvider.notifier)
        .updateUser(updatedUser)
        .then(
          (response) => {
            if (_image != null) _image = null,
            showSnackBar(
              context,
              'Profile updated successfully',
              ContentType.success,
            ),
            setState(() {
              isLoading = false;
            }),
          },
        )
        .catchError(
      (Object error) {
        showSnackBar(context, error.toString(), ContentType.failure);
        setState(() {
          isLoading = false;
        });
        throw Error();
      },
    );
  }

  Future<void> _signOut() async {
    await ref
        .read(userProvider.notifier)
        .signOut()
        .then(
          (response) => Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute<void>(builder: (_) => const ProfileScreen()),
            (Route<dynamic> route) => false,
          ),
        )
        .catchError(
          (Object error) => {
            showSnackBar(context, error.toString(), ContentType.failure),
            throw Error(),
          },
        );
  }

  Future<void> _deleteUser() async {
    await ref
        .read(userProvider.notifier)
        .deleteUser()
        .then(
          (response) => {
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute<void>(builder: (_) => const ProfileScreen()),
              (Route<dynamic> route) => false,
            ),
            showSnackBar(context, response, ContentType.success),
          },
        )
        .catchError(
          (Object error) => {
            showSnackBar(context, error.toString(), ContentType.failure),
            throw Error(),
          },
        );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text(
            'Are you sure you want to delete your account? '
            'This action is irreversible.',
          ),
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop();
          },
        ),
        middle: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontSize: 23),
        ),
        trailing: IconButton(
          onPressed: _signOut,
          icon: const FaIcon(FontAwesomeIcons.arrowRightFromBracket),
          color: Colors.white,
          iconSize: 22,
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: RoundedBackground(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                ProfileImage(
                  user: widget.user,
                  image: _image,
                  onImagePick: _pickImage,
                ),
                const SizedBox(height: 40),
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
                        items: universityState.valueOrNull!.universities
                            .map((university) => university.name)
                            .toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedUniversity = value ?? '';
                            _selectedSchool = '';
                            _selectedMajor = '';
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
                          });
                        },
                        enabled: _selectedUniversity.isNotEmpty,
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
                        enabled: _selectedSchool.isNotEmpty,
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
                            child: CustomButton(
                              isLoading: isLoading,
                              onPressed: updateUser,
                              text: 'Update',
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              onPressed: () =>
                                  _showDeleteConfirmationDialog(context),
                              text: 'Delete',
                              color: Colors.grey.shade200,
                              textColor: Colors.red.shade600,
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
