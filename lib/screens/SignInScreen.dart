import 'package:flutter/foundation.dart';
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
  String? errorMessage;
  bool isLoading = false;
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
            isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Custombutton(
                    text: "Sign Up",
                    onTap: () async {
                      setState(() {
                        isLoading = true; // show loader
                        errorMessage = null; // reset error
                      });
                      try {
                        await authservice.loginUser(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                        Navigator.of(context).pushReplacement(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    Homescreen(),
                            transitionsBuilder:
                                (
                                  context,
                                  animation,
                                  secondaryAnimation,
                                  child,
                                ) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                            transitionDuration: const Duration(
                              milliseconds: 500,
                            ),
                          ),
                        );
                      } catch (e) {
                        setState(() {
                          errorMessage = e.toString();
                          isLoading = false;
                        });
                        if (kDebugMode) {
                          print(e);
                        }
                      }
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            Signupscreen(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        transitionDuration: const Duration(milliseconds: 500),
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
            const SizedBox(height: 30),
            if (errorMessage != null) ...[
              Text(
                errorMessage!,
                style: TextStyle(color: AppColors.customRed),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
