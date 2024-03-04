import 'package:flutter/cupertino.dart';

class CustomBuildText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final String fontFamily;
  final TextOverflow overflow;
  final int? maxLines;
  final TextDecoration? underline;
  // final TextAlign? textAlign;

  const CustomBuildText(
    this.text, {
    super.key,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontFamily = 'poppins',
    this.overflow = TextOverflow.visible,
    this.maxLines,
    this.underline,
    // this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamily: fontFamily,
        decoration: underline,
      ),
      overflow: overflow,
      maxLines: maxLines,
      // textAlign: textAlign,
    );
  }
}
