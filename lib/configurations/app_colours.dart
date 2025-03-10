import 'package:flutter/material.dart';

@immutable
class AppColors {
  static const backgroundColorLight = const Color(0xffffffff);
  static const backgroundColorDark = const Color(0xff273342);

  static var primaryColorLight = const Color(0xffff992c); // Frontground color
  static var secondaryColorLight = const Color(0xffd9d9d9); // Background color
  static var primaryColorDark = const Color(0xFFFF992C);
  static var secondaryColorDark = const Color(0xff737373);

  static var surfaceColorLight = const Color(0xffffffff);
  static var surfaceColorDark = const Color(0xffffffff);
  static var onSurfaceColorLight = const Color(0xff000000);
  static var onSurfaceColorDark = const Color(0xff000000);

  static var primaryTextColorLight = const Color(0xff000000); // Text
  static var primaryTextColorDark = const Color(0xffffffff);
  static var secondaryTextColorLight = const Color(0xff000000);
  static var secondaryTextColorDark = const Color(0xffffffff);
  static var generalTextColorLight = const Color(0xff000000);
  static var generalTextColorDark = const Color(0xffffffff);

  static const loginButtonTextColor = Colors.black;
  static const contactSellerButton = Colors.lightGreen;
  static const orderViewPrice = Colors.amber;
  static const profileButtons = Colors.white70;

  const AppColors._();
}
