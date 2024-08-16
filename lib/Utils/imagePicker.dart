import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> imagePicker() async {
  final image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );
  if (image != null) {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      maxHeight: 500,
      maxWidth: 500,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
          lockAspectRatio: true,
          showCropGrid: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          resetAspectRatioEnabled: false,
          resetButtonHidden: true,
          showCancelConfirmationDialog: true,
          aspectRatioLockEnabled: true,
          embedInNavigationController: true,
        ),
      ],
    );
    return File(croppedImage!.path);
  }
  return null;
}
