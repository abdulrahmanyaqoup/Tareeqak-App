import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

void showSnackBar(BuildContext context, String text, ContentType contentType) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Align(
          alignment: Alignment.topCenter,
          child: AwesomeSnackbarContent(
            title: 'Note:',
            titleFontSize: 16,
            messageFontSize: 14,
            message: text,
            contentType: contentType,
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
      dismissDirection: DismissDirection.horizontal,
      margin: const EdgeInsets.only(left: 40, right: 40, top: 100),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}
