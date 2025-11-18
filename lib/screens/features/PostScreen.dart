import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Postscreen extends StatelessWidget {
  const Postscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Postscreen",
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
