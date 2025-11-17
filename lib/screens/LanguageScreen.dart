// ignore: file_names
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Languagescreen extends StatefulWidget {
  const Languagescreen({super.key});

  @override
  State<Languagescreen> createState() => _LanguagescreenState();
}

class _LanguagescreenState extends State<Languagescreen> {
  final List<String> items = [
    "Go",
    "JS/TS",
    "Kotlin",
    "Java",
    "Python",
    "Ruby",
    "PHP",
    "Swift",
    "C",
    "C++",
    "HTML 🤣",
    "CSS 😎",
    "Rust 🙈",
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
              "What is your first sight love ?",
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
                      print(items[index]);
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
