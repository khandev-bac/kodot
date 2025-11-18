import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/widget/CustomButton.dart';

class ProfilSreen extends StatelessWidget {
  const ProfilSreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Authservice authservice = Authservice();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ProfilSreen",
                style: TextStyle(
                  color: AppColors.customWhite,
                  fontFamily: "Jost",
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 30),
              Custombutton(
                text: "Logout",
                onTap: () async {
                  authservice.signOut();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
