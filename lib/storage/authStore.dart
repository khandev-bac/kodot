import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final user = FirebaseAuth.instance.currentUser;
final userId = user?.uid;
final storage = FlutterSecureStorage();
Future<void> writeUserId() async {
  await storage.write(key: "userId", value: userId);
}

Future<String?> readUserId() async {
  return await storage.read(key: "userId");
}
