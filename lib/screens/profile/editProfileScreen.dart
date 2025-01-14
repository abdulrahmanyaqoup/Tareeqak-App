import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../model/models.dart';
import '../../provider/universityProvider.dart';
import '../../provider/userProvider.dart';
import '../../utils/imagePicker.dart';
import '../../widgets/confirmationDialog.dart';
import '../../widgets/customButton.dart';
import '../../widgets/dropdown.dart';
import '../../widgets/snackBar.dart';
import '../../widgets/textfield.dart';
import 'components/profileImage.dart';
import 'components/roundedBackground.dart';
import 'profileScreen.dart';

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (1, 1);

  @override
  String get name => '1x1 (customized)';
}

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({required this.user, super.key});

  final User user;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends ConsumerState<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  File? _persistentImage;
  File? _image;
  String _selectedUniversity = '';
  String _selectedSchool = '';
  String _selectedMajor = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameController = TextEditingController(text: user.name);
    _contactController = TextEditingController(text: user.userProps.contact);
    _selectedUniversity = user.userProps.university;
    _selectedSchool = user.userProps.school;
    _selectedMajor = user.userProps.major;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  Future<void> updateUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    final updatedUserProps = UserProps(
      university: _selectedUniversity,
      school: _selectedSchool,
      major: _selectedMajor,
      contact: _contactController.text.replaceAll(
        RegExp(r'\s+'),
        '',
      ),
      image: _image?.path ?? '',
    );
    final updatedUser = User(
      email: widget.user.email,
      name: _nameController.text,
      userProps: updatedUserProps,
    );
    await ref
        .read(userProvider.notifier)
        .updateUser(updatedUser)
        .then(
          (response) => {
            showSnackBar(
              'Profile updated successfully',
              ContentType.success,
            ),
            setState(() {
              if (_image != null) _image = null;
              _isLoading = false;
            }),
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

  Future<void> _register() async {
    await ref
        .read(userProvider.notifier)
        .logout()
        .then(
          (response) => {
            if (mounted)
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute<void>(builder: (_) => const ProfileScreen()),
                (Route<dynamic> route) => false,
              ),
          },
        )
        .catchError(
      (Object error) {
        showSnackBar(error.toString(), ContentType.failure);
        throw Error();
      },
    );
  }

  Future<void> _deleteUser() async {
    await ref
        .read(userProvider.notifier)
        .deleteUser()
        .then(
          (response) => {
            if (mounted)
              Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute<void>(builder: (_) => const ProfileScreen()),
                (Route<dynamic> route) => false,
              ),
            showSnackBar(response, ContentType.success),
          },
        )
        .catchError((Object error) {
      showSnackBar(error.toString(), ContentType.failure);
      throw Error();
    });
  }

  Future<void> _pickImage() async {
    final image = await imagePicker();
    if (image == null) return;
    setState(() {
      _image = File(image.path);
      _persistentImage = _image;
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
          onPressed: _register,
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
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                ProfileImage(
                  key: ValueKey(widget.user.userProps.image),
                  userImage: widget.user.userProps.image,
                  onImagePick: _pickImage,
                  pickedImage: _persistentImage,
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
                        autoFillHints: const [AutofillHints.name],
                        keyboardType: TextInputType.name,
                        controller: _nameController,
                        hintText: 'Enter your name',
                        obscureText: false,
                        prefixIcon: const Icon(CupertinoIcons.person),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name can't be empty!";
                          }
                          return null;
                        },
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
                          });
                        },
                        enabled: _selectedUniversity.isNotEmpty,
                      ),
                      const SizedBox(height: 20),
                      Dropdown(
                        value: _selectedMajor,
                        hintText: 'Select your major',
                        prefixIcon: CupertinoIcons.pencil,
                        items: majors.map((major) => major.name).toList(),
                        onChanged: (String? value) {
                          setState(() => _selectedMajor = value ?? '');
                        },
                        enabled: _selectedSchool.isNotEmpty,
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        autoFillHints: const [AutofillHints.telephoneNumber],
                        keyboardType: TextInputType.phone,
                        controller: _contactController,
                        hintText: 'Enter your phone number',
                        obscureText: false,
                        prefixIcon: const Icon(CupertinoIcons.phone),
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
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              isLoading: _isLoading,
                              onPressed: updateUser,
                              text: 'Update',
                              textColor: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomButton(
                              onPressed: () => showDeleteConfirmationDialog(
                                context: context,
                                onDelete: _deleteUser,
                              ),
                              text: 'Delete',
                              color: Colors.red,
                              textColor: Colors.white,
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
