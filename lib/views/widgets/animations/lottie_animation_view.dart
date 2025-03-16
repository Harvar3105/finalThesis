import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnimationView extends StatelessWidget {
  final LottieAnimation animation;
  final bool repeat;
  final bool reverse;

  const LottieAnimationView({
    super.key,
    required this.animation,
    this.repeat = true,
    this.reverse = false,
  });

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      animation.fullPath,
      reverse: reverse,
      repeat: repeat,
    );
  }
}

enum LottieAnimation {
  notFound(name: 'notFound'),
  empty(name: 'empty'),
  loading(name: 'loading'),
  error(name: 'error');

  final String name;

  const LottieAnimation({
    required this.name,
  });
}

extension GetFullPath on LottieAnimation {
  String get fullPath => 'assets/animations/$name.json';
}
