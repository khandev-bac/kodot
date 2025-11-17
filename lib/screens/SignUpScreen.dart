import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/Textfeild.dart';

class Signupscreen extends StatefulWidget {
  const Signupscreen({super.key});

  @override
  State<Signupscreen> createState() => _SignupscreenState();
}

class _SignupscreenState extends State<Signupscreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: AppColors.customBlack),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Create your Account",
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
            Custombutton(text: "Sign Up"),
            // const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white70),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to login
                  },
                  child: Text(
                    "Sign In",
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
