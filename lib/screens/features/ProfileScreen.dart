import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class ProfilSreen extends StatelessWidget {
  const ProfilSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "ProfilSreen",
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
