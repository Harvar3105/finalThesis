import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AnimationWithText extends StatelessWidget {
  final Widget animation;
  final String text;
  const AnimationWithText({super.key, required this.animation, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        animation,
        const SizedBox(height: 20),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
        ),
      ],
    );
  }

}