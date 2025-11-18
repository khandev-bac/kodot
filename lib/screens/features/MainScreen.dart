import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "MainScreen",
          style: TextStyle(
            color: AppColors.customWhite,
            fontFamily: "Jost",
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
