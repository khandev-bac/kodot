import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:kodot/contants/AppUrls.dart';
import 'package:http/http.dart' as http;

// idToken
class Authservice {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

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
      firebaseAuth(idToken!);
    } catch (e) {
      if (kDebugMode) {
        print("Google Login Flow Error: $e");
      }
    }
  }

  void firebaseAuth(String idToken) async {
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
        }
        if (kDebugMode) {
          print("Body: ${res.body}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error $e");
      }
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
      firebaseAuth(idToken!);
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // final idToken = await credential.user?.getIdToken();
      // firebaseAuth(idToken!);
    } catch (e) {
      if (kDebugMode) {
        print("Sign up error: $e");
      }
      rethrow;
    }
    return null;
  }
}
