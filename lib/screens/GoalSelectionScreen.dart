// ignore: file_names
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Goalselectionscreen extends StatefulWidget {
  const Goalselectionscreen({super.key});

  @override
  State<Goalselectionscreen> createState() => _GoalselectionscreenState();
}

class _GoalselectionscreenState extends State<Goalselectionscreen> {
  final List<String> items = [
    "Improve my coding skills",
    "Help other developers",
    "Meet other developers",
    "Share knowledge",
    "Stay motivated",
    "Or love to be in tech world",
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
              "In what world are you in ?",
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
