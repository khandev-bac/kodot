import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:kodot/contants/AppUrls.dart';
import 'package:http/http.dart' as http;

class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String?> getUserIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String? idToken = await user.getIdToken(true);
        return idToken;
      } catch (e) {
        if (kDebugMode) print('Error getting ID token: $e');
        return null;
      }
    }
    return null;
  }

  Future<UserCredential?> googleLogin() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      googleAuthProvider.addScope("email");
      googleAuthProvider.addScope("profile");
      final UserCredential credential = await _auth.signInWithProvider(
        googleAuthProvider,
      );
      return credential;
    } catch (e) {
      if (kDebugMode) {
        print("Google Sign-In Error: $e");
      }
      rethrow;
    }
  }

  Future<void> googleLoginFlow() async {
    try {
      final userCred = await googleLogin();
      final idToken = await userCred?.user?.getIdToken();
      if (kDebugMode) {
        print("ID TOKEN -> $idToken");
      }
      await firebaseAuth(idToken!);

      // Sync FCM token after successful login
      await syncFCMTokenAfterLogin();
    } catch (e) {
      if (kDebugMode) {
        print("Google Login Flow Error: $e");
      }
    }
  }

  Future<void> firebaseAuth(String idToken) async {
    try {
      final url = Uri.parse(Appurls.backendURL);
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"idToken": idToken}),
      );
      if (res.statusCode == 200) {
        if (kDebugMode) {
          print("Status: ${res.statusCode}");
          print("Body: ${res.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  // Sync FCM token with backend after login
  Future<void> syncFCMTokenAfterLogin() async {
    try {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final idToken = await _auth.currentUser?.getIdToken();

      if (fcmToken == null || idToken == null) return;

      final url = Uri.parse('${Appurls.backendProURL}/sync-fcm-token');
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({"fcm_token": fcmToken}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print("FCM token synced successfully");
      } else {
        if (kDebugMode) print("Failed to sync FCM token: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) print("Error syncing FCM token: $e");
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      if (kDebugMode) {
        print("Signed out successfully.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Sign-out error: $e");
      }
    }
  }

  Future<UserCredential?> signupUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final idToken = await credential.user?.getIdToken();
      await firebaseAuth(idToken!);

      // Sync FCM token after successful signup
      await syncFCMTokenAfterLogin();

      return credential;
    } catch (e) {
      if (kDebugMode) {
        print("Sign up error: $e");
      }
      rethrow;
    }
  }

  Future<UserCredential?> loginUser(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Sync FCM token after successful login
      await syncFCMTokenAfterLogin();

      return credential;
    } catch (e) {
      if (kDebugMode) {
        print("Login error: $e");
      }
      rethrow;
    }
  }

  Future<bool> UpdateProfileImageService(File imageFile) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendProURL}/update_profile_image");
      final request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $idToken";
      request.files.add(
        await http.MultipartFile.fromPath("profile_image", imageFile.path),
      );
      final response = await request.send();
      final res = await http.Response.fromStream(response);
      if (res.statusCode == 200) {
        if (kDebugMode) {
          print("Profile updated: ${res.body}");
        }
        return true;
      } else {
        if (kDebugMode) {
          print("Failed: ${res.body}");
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Update error: $e");
      }
      return false;
    }
  }
}
