import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final String labelText;
  final TextInputType? keyboard;
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hint,
    this.keyboard,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: Colors.grey.shade700),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        keyboardType: keyboard,
      ),
    );
  }
}
