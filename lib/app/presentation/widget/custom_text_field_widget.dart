import 'package:flutter/material.dart';

Widget basicTextField(
  String label, {
  TextStyle? labelStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  bool? isEnabled = true,
  String? hintText,
  int? maxLines = 1,
  int? maxLength,
  bool? addSpace = true,
  Future Function()? onTap,
  TextInputType? textInputType = TextInputType.text,
  bool? isPassword = false,
  bool? isPasswordHide = false,
  required TextEditingController controller,
  void Function()? onPressedIconPassword,
}) {
  return Column(
    // crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: labelStyle,
      ),
      if (addSpace!) const SizedBox(height: 8),
      TextField(
        enabled: isEnabled,
        obscureText: isPasswordHide! ? true : false,
        controller: controller,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
        ),
        keyboardType: textInputType,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          contentPadding:
              const EdgeInsets.all(12.0), // Sesuaikan tinggi di sini
          fillColor: Colors.grey[200], // Warna latar belakang abu-abu
          filled: true,
          suffixIcon: isPassword!
              ? IconButton(
                  icon: Icon(
                      isPasswordHide ? Icons.visibility_off : Icons.visibility),
                  onPressed: onPressedIconPassword,
                )
              : null,
        ),
        readOnly: onTap != null,
        onTap: onTap,
      ),
    ],
  );
}
