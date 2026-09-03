import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DefaultTextField extends StatefulWidget {
  final String text;
  final String? initialValue;
  final Function(String) onChanged;
  final IconData icon;
  final bool isPassword;
  final double verticalPadding;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  final Color backgroundColor;
  final bool hasBorders;
  final TextEditingController? controller;
  final FocusNode? focusNode;

  const DefaultTextField({
    super.key,
    required this.text,
    this.initialValue,
    required this.icon,
    required this.onChanged,
    this.isPassword = false,
    this.verticalPadding = 18,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.errorText,
    this.backgroundColor = Colors.white,
    this.hasBorders = true,
    this.controller,
    this.focusNode,
  });

  @override
  State<DefaultTextField> createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: widget.isPassword ? _obscureText : false,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: widget.backgroundColor,
        filled: true,
        errorText: widget.errorText,
        contentPadding: EdgeInsets.symmetric(
          vertical: widget.verticalPadding,
          horizontal: 20,
        ),
        labelText: widget.text,
        prefixIcon: Icon(widget.icon, color: Colors.black),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        enabledBorder: widget.hasBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black54),
              )
            : InputBorder.none,
        focusedBorder: widget.hasBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.black),
              )
            : InputBorder.none,
        errorBorder: widget.hasBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red),
              )
            : InputBorder.none,
        focusedErrorBorder: widget.hasBorders
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: Colors.red),
              )
            : InputBorder.none,
      ),
    );
  }
}
