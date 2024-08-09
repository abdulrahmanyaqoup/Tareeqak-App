import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text, ContentType contentType) {
  final snackBar = SnackBar(
    content: AwesomeSnackbarContent(
      title: text,
      titleFontSize: 16,
      messageFontSize: 0,
      message: '',
      contentType: contentType,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
