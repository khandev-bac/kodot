import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kodot/contants/AppImages.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/screens/SignUpScreen.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/widget/CustomButton.dart';

class Authscreen extends StatelessWidget {
  const Authscreen({super.key});
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
              Image.asset(Appimages.wordlogobg, width: 500, height: 300),
              const SizedBox(height: 30),
              Text(
                "Become Greate Engineer Together",
                style: TextStyle(
                  color: AppColors.customWhite,
                  fontFamily: "Jost",
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Custombutton(
                text: "Continue with Google",
                onTap: () async {
                  await authservice.googleLoginFlow();
                },
              ),
              const SizedBox(height: 30),
              Custombutton(
                text: "Continue with Email",
                onTap: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Signupscreen(), // Replace with your target page
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
