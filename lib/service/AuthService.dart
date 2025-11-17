import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
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
      print("Google Sign-In Error: $e");
      rethrow;
    }
  }

  Future<void> googleLoginFlow() async {
    try {
      final userCred = await googleLogin();
      final idToken = await userCred?.user?.getIdToken();
      print("ID TOKEN -> $idToken");
      firebaseAuth(idToken!);
    } catch (e) {
      print("Google Login Flow Error: $e");
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
        print("Status: ${res.statusCode}");
        print("Body: ${res.body}");
      }
    } catch (e) {
      print("Error $e");
    }
  }

  void signOut() async {
    try {
      await _auth.signOut();
      print("Signed out successfully.");
    } catch (e) {
      print("Sign-out error: $e");
    }
  }
}
