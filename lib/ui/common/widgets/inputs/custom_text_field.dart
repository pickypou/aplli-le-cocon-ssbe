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
    final size = MediaQuery.sizeOf(context);
    final double textFieldWidth = size.width > 600
        ? size.width * 0.4 // Largeur plus grande pour les écrans larges
        : size.width * 0.8; // Largeur plus petite pour les écrans étroits
    final borderColor = theme.colorScheme.onSurface;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width > 600 ? 16.0 : 8.0, // Ajuste les marges latérales
        vertical: 8.0, // Marge verticale constante
      ),
      child: Center(
        child: SizedBox(
          width: textFieldWidth,
          child: TextField(
            controller: controller,
            style: textStyleText(context).copyWith(fontSize: 14.0),
            maxLines: maxLines,
            obscureText: obscureText,
            decoration: InputDecoration(
              isDense: true, // Réduit l'espace vertical
              labelText: labelText,
              labelStyle: textStyleInput(context, labelText),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0), // Ajuste la courbure
                borderSide: BorderSide(
                  color: borderColor,
                  width: 1.5, // Épaisseur de la bordure
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: theme.colorScheme.primary, // Couleur primaire au focus
                  width: 2.0, // Épaisseur accrue au focus
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: size.height * 0.01, // Hauteur relative à l'écran
                horizontal: size.width * 0.03, // Largeur relative à l'écran
              ),
            ),
          ),
        ),
      ),
    );
  }
}
