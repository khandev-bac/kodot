import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:kodot/contants/AppUrls.dart';
import 'package:kodot/models/AppSuccessModel.dart';
import 'package:kodot/models/CreatePostModel.dart';
import 'package:http/http.dart' as http;
import 'package:kodot/models/FeedModel.dart';
import 'package:kodot/models/InboxMessageModel.dart';
import 'package:kodot/models/RecivedMessage.dart';
import 'package:kodot/models/UserUpdateInfo.dart';

class Postservice {
  Future<String?> getFCMToken() async {
    try {
      final FirebaseMessaging _messaging = FirebaseMessaging.instance;
      String? token = await _messaging.getToken();
      return token;
    } catch (e) {
      if (kDebugMode) print("Failed to get FCM token: $e");
      return null;
    }
  }

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

  // Sync FCM token with backend after login
  Future<void> syncFCMTokenWithBackend() async {
    try {
      final fcmToken = await getFCMToken();
      final idToken = await getUserIdToken();

      if (fcmToken == null || idToken == null) return;

      final url = Uri.parse('${Appurls.backendProURL}/sync-fcm-token');
      await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({"fcm_token": fcmToken}),
      );
    } catch (e) {
      if (kDebugMode) print("Error syncing FCM token: $e");
    }
  }

  // Create inbox message - returns author's FCM token
  Future<Map<String, dynamic>?> CreateInboxMessage(
    String? postId,
    String? message,
  ) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLInbox}/${postId}");
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
        body: jsonEncode({"message": message}),
      );

      final resbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return resbody["data"];
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("CreateInboxMessage ERROR: $e");
      return null;
    }
  }

  // Boost post - returns author's FCM token
  Future<Map<String, dynamic>?> Boost(String? postId) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLBoost}/$postId");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );

      if (response.body.isEmpty) return null;

      final resbody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return resbody["data"];
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Boost ERROR: $e");
      return null;
    }
  }

  // Send FCM notification directly to token
  Future<void> sendFCMNotification(String token, String type) async {
    try {
      final url = Uri.parse('${Appurls.backendURLNotification}/');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token, "type": type}),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) print("FCM notification sent successfully");
      } else {
        if (kDebugMode)
          print("Failed to send FCM notification: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) print("Error sending FCM notification: $e");
    }
  }

  // ... rest of your existing methods ...

  Future<AppSuccessMessage<Createpostmodel?>?> CreateCodePostService({
    required String code,
    required String caption,
    required List<String?> tags,
  }) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/post");
      var request = http.MultipartRequest("POST", url);
      request.headers["Authorization"] = "Bearer $idToken";
      if (code.trim().isNotEmpty) {
        request.fields["code"] = code;
      }
      if (caption.trim().isNotEmpty) {
        request.fields["caption"] = caption;
      }
      if (tags.isNotEmpty) {
        request.fields["tags"] = tags.join(",");
      }
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AppSuccessMessage.fromJson(
          data,
          (json) => Createpostmodel.fromJson(json),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Create code post failed: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<Userinfo>?> GetUserData() async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendProURL}/user");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);
        return AppSuccessMessage.fromJson(
          resBody,
          (data) => Userinfo.fromJson(data),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Error getting userData: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<FeedPostModel?>?> CreateImagePost({
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
        return AppSuccessMessage.fromJson(
          data,
          (json) => FeedPostModel.fromJson(json),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Error creating post: $e");
      return null;
    }
  }

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
        return {"message": data["message"], "statusCode": data["statusCode"]};
      } else {
        return {"message": data["message"], "statusCode": data["statusCode"]};
      }
    } catch (e) {
      if (kDebugMode) print("Error editing post: $e");
      return {"message": "Error occurred", "statusCode": 500};
    }
  }

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
        return {"message": data["message"], "statusCode": data["statusCode"]};
      } else {
        return {"message": data["message"], "statusCode": data["statusCode"]};
      }
    } catch (e) {
      return {"message": "Something went wrong", "statusCode": 500};
    }
  }

  Future<AppSuccessMessage<List<FeedPostModel?>>?> GetAllUserPost() async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      final responseBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AppSuccessMessage.fromJson(
          responseBody,
          (json) => (json as List)
              .map((item) => FeedPostModel.fromJson(item))
              .toList(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("GetAllUserPost ERROR: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<List<FeedPostModel>>?> GetAllPosts() async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/home");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      final resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AppSuccessMessage.fromJson(
          resBody,
          (data) => (data as List)
              .map((item) => FeedPostModel.fromJson(item))
              .toList(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("GetAllPosts ERROR: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<List<FeedPostModel>>?> SearchQuery(
    String search,
  ) async {
    try {
      final url = Uri.parse("${Appurls.backendURLSearch}?search=$search");
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
      );
      final resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AppSuccessMessage.fromJson(
          resBody,
          (data) => (data as List)
              .map((item) => FeedPostModel.fromJson(item))
              .toList(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("Search ERROR: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<List<FeedPostModel>>?> GetPostId(
    String postId,
  ) async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLPost}/$postId");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      final resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AppSuccessMessage.fromJson(
          resBody,
          (data) => (data as List)
              .map((item) => FeedPostModel.fromJson(item))
              .toList(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("GetPostById ERROR: $e");
      return null;
    }
  }

  Future<AppSuccessMessage<List<InboxMessageModel?>>?> GetAllUserInbox() async {
    try {
      final idToken = await getUserIdToken();
      final url = Uri.parse("${Appurls.backendURLInbox}/");
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $idToken",
        },
      );
      final resbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return AppSuccessMessage.fromJson(
          resbody,
          (data) => (data as List)
              .map((json) => InboxMessageModel.fromJson(json))
              .toList(),
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) print("GetAllUserInbox ERROR: $e");
      return null;
    }
  }
}
