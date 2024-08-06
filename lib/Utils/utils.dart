import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showSnackBar(BuildContext context, String text, ContentType contentType) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Container(
        height: 80,
        width: double.infinity,
        margin: const EdgeInsets.only(bottom:0),
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
}
