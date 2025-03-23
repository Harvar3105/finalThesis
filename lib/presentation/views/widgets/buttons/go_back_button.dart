import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        context.pop();
      },
      icon: const Icon(Icons.arrow_back_rounded, size: 35,),
      style: TextButton.styleFrom(
        backgroundColor: theme.colorScheme.secondary,
        padding: const EdgeInsets.all(14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
  }
}