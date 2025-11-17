import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/widget/CustomButton.dart';

class Homescreen extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final Authservice authservice = Authservice();
    return Scaffold(
      body: Center(
        child: user == null
            ? Text("No user logged in")
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome, ${user!.displayName}",
                    style: TextStyle(color: AppColors.customWhite),
                  ),
                  Text(
                    "Email: ${user!.email}",
                    style: TextStyle(color: AppColors.customWhite),
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(user!.photoURL ?? ""),
                    radius: 40,
                  ),
                  Custombutton(
                    text: "Logout",
                    onTap: () async {
                      authservice.signOut();
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
