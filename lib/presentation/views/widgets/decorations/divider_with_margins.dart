import 'package:flutter/material.dart';

class DividerWithMargins extends StatelessWidget {
  final double margin;

  const DividerWithMargins(this.margin, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: margin,
        ),
        const Divider(),
        SizedBox(
          height: margin,
        )
      ],
    );
  }
}
