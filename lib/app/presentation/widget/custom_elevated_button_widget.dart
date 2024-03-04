import 'package:flutter/material.dart';
import 'package:todolist_motion/app/presentation/widget/custom_build_text_widget.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? backgroundColor;
  final double? minWidth;
  final double? minHeight;
  final double borderRadius;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? textColor;
  final Color? foregroundColor; // Tambahkan parameter foregroundColor
  final BorderSide? borderSide;
 
  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.minWidth,
    this.minHeight,
    this.borderRadius = 20.0,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14.0,
    this.textColor,
    this.foregroundColor, // Tambahkan parameter foregroundColor
    this.borderSide = const BorderSide(
      width: 2,
      color: Color(0xFF0E5970),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? Colors.amber,
        foregroundColor: foregroundColor ?? Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: borderSide ?? BorderSide.none,
        ),
        minimumSize: Size(minWidth ?? double.infinity, minHeight ?? 40),
      ),
      child: CustomBuildText(text,
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: textColor ?? Colors.white),
    );
  }
}
