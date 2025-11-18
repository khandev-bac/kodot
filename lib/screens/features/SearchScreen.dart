import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Searchscreen extends StatelessWidget {
  const Searchscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Searchscreen",
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
