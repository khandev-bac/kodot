// ignore: file_names
import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';
import 'package:kodot/widget/CustomButton.dart';
import 'package:kodot/widget/CustomCircle.dart';

class Yearsscreen extends StatefulWidget {
  const Yearsscreen({super.key});

  @override
  State<Yearsscreen> createState() => _YearsscreenState();
}

class _YearsscreenState extends State<Yearsscreen> {
  final List<String> items = [
    "just started and just loved it",
    "founder or builder",
    "builder and CTO",
    "Experience Brainer",
    "Maanger",
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
              "How many year are you doing ?",
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
