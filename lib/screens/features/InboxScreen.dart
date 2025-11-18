import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Inboxscreen extends StatelessWidget {
  const Inboxscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Inboxscreen",
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
