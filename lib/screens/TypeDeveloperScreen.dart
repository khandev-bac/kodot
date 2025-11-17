// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Typedeveloperscreen extends StatefulWidget {
  const Typedeveloperscreen({super.key});

  @override
  State<Typedeveloperscreen> createState() => _TypedeveloperscreenState();
}

class _TypedeveloperscreenState extends State<Typedeveloperscreen> {
  final List<String> items = [
    "night owl with dark mode",
    "Finishes tasks before others start them.",
    "Works smart, not hard",
    "coffee more than code 🤣",
    "Codes for joy, not deadlines.",
    "Chaos = creativity",
    "Code less dream more",
    "Chill vibe with vscode",
    "love kissing bugs",
  ];

  int selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What you love to do ?",
              style: TextStyle(
                fontFamily: "Jost",
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.customWhite,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Center(
              child: Wrap(
                spacing: 15,
                runSpacing: 12,
                children: List.generate(items.length, (index) {
                  return AnimatedCapsuleButton(
                    text: items[index],
                    isSelected: selectedIndex == index,
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      if (kDebugMode) {
                        print(items[index]);
                      }
                    },
                  );
                }),
              ),
            ),
            const SizedBox(height: 40),
            Custombutton(text: "Continue"),
          ],
        ),
      ),
    );
  }
}
