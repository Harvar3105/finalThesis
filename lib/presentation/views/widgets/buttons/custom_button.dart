import 'package:flutter/material.dart';

import '../../../../configurations/app_colours.dart';


class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(15),
        backgroundColor: backgroundColor ?? AppColors.primaryColorLight,
        foregroundColor: foregroundColor ?? AppColors.secondaryColorLight,
        textStyle: TextStyle(
          fontSize: fontSize ?? 25,
          fontWeight: fontWeight ?? FontWeight.normal,
        ),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
