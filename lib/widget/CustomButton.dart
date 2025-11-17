import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class Custombutton extends StatelessWidget {
  final Color? textColor;
  final String text;
  final Color? btnTextColor;
  final VoidCallback? onTap;
  final double? fontSize;
  const Custombutton({
    super.key,
    this.textColor,
    this.onTap,
    required this.text,
    this.btnTextColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        height: 76,
        decoration: BoxDecoration(
          color: textColor ?? AppColors.customWhite,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: btnTextColor ?? AppColors.customBlack,
              fontFamily: "Jost",
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 18,
            ),
          ),
        ),
      ),
    );
  }
}
