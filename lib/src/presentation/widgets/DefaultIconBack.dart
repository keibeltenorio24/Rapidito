import 'package:flutter/material.dart';

class DefaultIconBack extends StatelessWidget {
  Color color;
  double size;
  EdgeInsetsGeometry? margin;

  DefaultIconBack({this.color = Colors.white, this.size = 30, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      margin: margin,
      child: IconButton(
        icon: Icon(Icons.arrow_back, color: color, size: size),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
