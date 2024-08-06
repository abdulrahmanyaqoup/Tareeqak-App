import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

class CustomSnackBar extends StatelessWidget {
  final BuildContext context;
  final String text;
  final ContentType contentType;

  const CustomSnackBar({
    super.key,
    required this.context,
    required this.text,
    required this.contentType,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Container(
            height: 80,
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 0),
            child: AwesomeSnackbarContent(
              title: 'Note:',
              titleFontSize: 16,
              messageFontSize: 14,
              message: text,
              contentType: contentType,
            ),
          ),
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    });

    return Container();
  }
}
