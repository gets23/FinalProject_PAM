import 'package:flutter/material.dart';
import '/config/theme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final inputTheme = Theme.of(context).inputDecorationTheme;
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: AppTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: inputTheme.labelStyle,
        hintText: hint,
        hintStyle: inputTheme.hintStyle,
        prefixIcon: Icon(prefixIcon, color: AppTheme.primaryColor),
        suffixIcon: suffixIcon,
        filled: inputTheme.filled,
        fillColor: inputTheme.fillColor,
        border: inputTheme.border,
        enabledBorder: inputTheme.enabledBorder,
        focusedBorder: inputTheme.focusedBorder,
        errorBorder: inputTheme.errorBorder,
        focusedErrorBorder: inputTheme.focusedErrorBorder,
        contentPadding: inputTheme.contentPadding,
      ),
    );
  }
}
