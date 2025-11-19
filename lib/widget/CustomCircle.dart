import 'package:flutter/material.dart';
import 'package:kodot/contants/Colors.dart';

class AnimatedCapsuleButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color btnColor;
  const AnimatedCapsuleButton({
    super.key,
    required this.text,

    required this.onTap,
    required this.btnColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: 1.08,
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: AppColors.customWhite, width: 0.8),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            style: TextStyle(
              fontFamily: "Jost",
              color: AppColors.customWhite,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}
