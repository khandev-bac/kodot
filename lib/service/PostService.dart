import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:kodot/contants/AppUrls.dart';
import 'package:kodot/models/AppSuccessModel.dart';
import 'package:kodot/models/CreatePostModel.dart';
import 'package:http/http.dart' as http;

class Postservice {
  Future<String?> getUserIdToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        String? idToken = await user.getIdToken();
        if (kDebugMode) {
          print('User ID Token: $idToken');
        }
        return idToken;
      } catch (e) {
        if (kDebugMode) {
          print('Error getting ID token: $e');
        }
        return null;
      }
    } else {
      if (kDebugMode) {
        print('No user is currently logged in.');
      }
      return null;
    }
  }

  // post create
  // ignore: non_constant_identifier_names
  Future<AppSuccessMessage<Createpostmodel?>?> CreateCodePostService({
    required String code,
    required String caption,
    required List<String?> tags,
  }) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/post");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({"code": code, "caption": caption, "tags": tags}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (kDebugMode) {
          print("Response data: ${data}");
        }
        return AppSuccessMessage.fromJson(
          data,
          (json) => Createpostmodel.fromJson(json),
        );
      } else {
        if (kDebugMode) {
          print('Error: ${response.statusCode}, body: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Create code post failed: $e");
      }
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future<AppSuccessMessage<Createpostmodel?>?> CreateImagePost({
    required File image,
    String? caption,
    List<String>? tags,
  }) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/post");
      var request = http.MultipartRequest("POST", url);
      request.headers.addAll({"Authorization": "Bearer $idToken"});
      request.files.add(
        await http.MultipartFile.fromPath("post_image", image.path),
      );
      if (caption != null) {
        request.fields["caption"] = caption;
      }
      if (tags != null) {
        request.fields["tags"] = tags.join(",");
      }
      var response = await request.send();
      final resBody = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        final data = jsonDecode(resBody);
        if (kDebugMode) {
          print("Response data: ${data}");
        }
        return AppSuccessMessage.fromJson(
          data,
          (json) => Createpostmodel.fromJson(json),
        );
      } else {
        if (kDebugMode) {
          print("Failed to create post: ${response.statusCode}");
        }
        if (kDebugMode) {
          print("Response string ${resBody}");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating post: $e");
      }
      return null;
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>> EditCreatedPost({
    String? caption,
    String? postId,
  }) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/$postId");
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({"caption": caption}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Edited post response: ${data}");
        }
        return {"message": data["message"], "statusCode": data["statusCode"]};
      } else {
        return {"message": data["message"], "statusCode": data["statusCode"]};
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error editing post: $e");
      }
      return {"message": "Error occurred", "statusCode": 500, "data": null};
    }
  }

  // ignore: non_constant_identifier_names
  Future<Map<String, dynamic>?> DeletePost({String? postId}) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/$postId");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("Edited post response: ${data}");
        }
        return {"message": data["message"], "statusCode": data["statusCode"]};
      } else {
        return {"message": data["message"], "statusCode": data["statusCode"]};
      }
    } catch (e) {
      return {"message": "Something went wrong", "statusCode": 500};
    }
  }
}
