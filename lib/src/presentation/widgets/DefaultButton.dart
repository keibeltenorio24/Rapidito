import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  // 1. Agregamos 'final' a todas las variables
  final Function() onPressed;
  final String text;
  final Color color;
  final Color textColor;

  // 2. Agregamos 'const' y 'super.key'
  const DefaultButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ElevatedButton(
        // 3. 👇 ¡Aquí estaba el error! Pasamos la función directamente
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text, style: TextStyle(fontSize: 18, color: textColor)),
      ),
    );
  }
}
