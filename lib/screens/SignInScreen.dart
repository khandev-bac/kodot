import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/screens/HomeScreen.dart';
import 'package:kodot/screens/SignUpScreen.dart';
import 'package:kodot/service/AuthService.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/Textfeild.dart';

class Signinscreen extends StatefulWidget {
  const Signinscreen({super.key});

  @override
  State<Signinscreen> createState() => _SigninscreenState();
}

class _SigninscreenState extends State<Signinscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Authservice authservice = Authservice();
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.customBlack),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Sign In to your Account ",
                style: TextStyle(
                  fontFamily: "Jost",
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: AppColors.customWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 60),
            AnimatedCapsuleTextField(
              hint: "Email",
              controller: emailController,
            ),
            const SizedBox(height: 20),
            AnimatedCapsuleTextField(
              hint: "Password",
              controller: passwordController,
              isPassowrd: true,
            ),
            const SizedBox(height: 30),
            Custombutton(
              text: "Sign In",
              onTap: () async {
                await authservice.loginUser(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Homescreen(), // Replace with your target page
                  ),
                );
              },
            ),
            // const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Don’t have account?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to login
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Signupscreen(), // Replace with your target page
                      ),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
