import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../Widgets/customButton.dart';
import '../../Widgets/snackBar.dart';
import '../../Widgets/textfield.dart';
import '../../api/userApi/userApi.dart';
import 'components/formContainer.dart';
import 'components/roundedBackground.dart';
import 'verifyScreen.dart';

@immutable
class ResetPassScreen extends ConsumerStatefulWidget {
  const ResetPassScreen({super.key});

  @override
  ConsumerState<ResetPassScreen> createState() => _ResetPassScreen();
}

class _ResetPassScreen extends ConsumerState<ResetPassScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final UserApi _api = UserApi();
  bool _isLoading = false;

  Future<void> _resetPassword(String email) async {
    setState(() => _isLoading = true);

    await _api.resetPassword(email).then((response) async {
      setState(() => _isLoading = false);
      showSnackBar(response, ContentType.success);
      if (!mounted) return;
      await Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute<void>(
          builder: (_) => VerifyScreen(
            email: _emailController.text,
            isSignup: false,
          ),
        ),
        (Route<dynamic> route) => route.isFirst,
      );
    }).catchError(
      (Object error) {
        setState(() => _isLoading = false);
        showSnackBar(error.toString(), ContentType.failure);
        throw Error();
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const Text(
                  'Reset Password',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
                const SizedBox(height: 20),
                const Icon(
                  Icons.lock,
                  color: Colors.white,
                  size: 100,
                ),
                const SizedBox(height: 20),
                FormContainer(
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Enter your email*',
                        prefixIcon: const Icon(CupertinoIcons.mail),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email can't be empty!";
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value)) {
                            return 'Enter a valid email address!';
                          }
                          return null;
                        },
                        obscureText: false,
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        isLoading: _isLoading,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _resetPassword(
                              _emailController.text,
                            );
                          }
                        },
                        text: 'Submit',
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
