import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Skillscreen extends StatefulWidget {
  const Skillscreen({super.key});

  @override
  State<Skillscreen> createState() => _SkillscreenState();
}

class _SkillscreenState extends State<Skillscreen> {
  final List<String> items = [
    "Backend",
    "Frontend",
    "Mobile",
    "AI",
    "System",
    "Devops",
    "Cyber Security",
    "Vibe coding 🤣",
    "Native Guy",
    "Hybrid Guy",
    "DSA",
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
              "What you love the most ?",
              style: TextStyle(
                fontFamily: "Jost",
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.customWhite,
              ),
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
