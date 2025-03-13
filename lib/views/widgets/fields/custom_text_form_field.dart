import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final TextInputType? keyboardType;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.validator,
    this.labelText,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
      obscureText: true,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}