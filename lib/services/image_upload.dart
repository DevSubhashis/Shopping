import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';

File imageFile;

class ImageUpload {
  static final ImageUpload _imageUpload = ImageUpload._internal();

  factory ImageUpload() {
    return _imageUpload;
  }

  ImageUpload._internal();

  Future<File> uploadImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio16x9
                ]
              : [
                  CropAspectRatioPreset.original,
                  CropAspectRatioPreset.square,
                  CropAspectRatioPreset.ratio3x2,
                  CropAspectRatioPreset.ratio4x3,
                  CropAspectRatioPreset.ratio5x3,
                  CropAspectRatioPreset.ratio5x4,
                  CropAspectRatioPreset.ratio7x5,
                  CropAspectRatioPreset.ratio16x9
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            title: 'Cropper',
          ));
      if (croppedFile != null) {
        imageFile = croppedFile;
        return imageFile;
      }
    }
  }

  // Future<File> uploadImage() {
  //   return ImagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     maxHeight: 512.0,
  //     maxWidth: 512.0,
  //   );
  // }
}
