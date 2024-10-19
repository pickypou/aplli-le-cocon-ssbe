import 'package:app_lecocon_ssbe/theme.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final int maxLines;
  final bool obscureText;

  const CustomTextField({
    super.key,
    required this.labelText,
    this.controller,
    required this.maxLines,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    double textFieldWidth = size.width * 0.8;
    final borderColor = theme.colorScheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: textFieldWidth,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(color: Colors.transparent),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: size.width / 20,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: textStyleInput(context, labelText),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: BorderSide(
                  color: borderColor,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: size.width / 20, // Ajuste ici pour réduire la hauteur
                horizontal: size.height / 10,
              ),
            ),
            obscureText: obscureText,
          ),
        ),
      ),
    );
  }
}
