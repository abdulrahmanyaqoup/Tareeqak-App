import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';

import '../main.dart';

void showSnackBar(String text, ContentType contentType) {
  final context = Tareeqak.navKey.currentContext;
  final snackBar = SnackBar(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
    content: AwesomeSnackbarContent(
      title: contentType.message,
      message: text,
      contentType: contentType,
    ),
    duration: const Duration(seconds: 3),
    behavior: SnackBarBehavior.fixed,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
  if (context != null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
