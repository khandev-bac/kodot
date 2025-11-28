import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kodot/service/AuthService.dart';

final Authservice authservice = Authservice();
Future<void> selectProfileImage(BuildContext context) async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked == null) return;

  File imageFile = File(picked.path);

  bool success = await authservice.UpdateProfileImageService(imageFile);

  if (success) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile updated!"),
        backgroundColor: Colors.green,
      ),
    );
    if (kDebugMode) {
      print("Profile updated!");
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to update."),
        backgroundColor: Colors.red,
      ),
    );
    if (kDebugMode) {
      print("Failed to update.");
    }
  }
}
