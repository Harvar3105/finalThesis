import 'package:flutter/material.dart';

@immutable
class AppColors {

  //Light mode
  static const backgroundColorLight = Color(0xffffffff);
  static var primaryColorLight = const Color(0xff8d1bff);
  static var secondaryColorLight = const Color(0xffd9d9d9);

  //Text
  static var primaryTextColorLight = const Color(0xff000000);
  static var secondaryTextColorLight = const Color(0xff2c2c2c);
  // static var generalTextColorLight = const Color(0xff000000);

  //Surface
  static var surfaceColorLight = const Color(0xffffffff);
  static var onSurfaceColorLight = const Color(0xff000000);

  //other
  static const iconThemeLight = IconThemeData(color: Colors.black);

  //----------------------------------------------------------------------------

  //Dark mode
  static const backgroundColorDark = Color(0xff273342);
  static var primaryColorDark = const Color(0xff8e07ff);
  static var secondaryColorDark = const Color(0xff737373);

  //Text
  static var primaryTextColorDark = const Color(0xffffffff);
  static var secondaryTextColorDark = const Color(0xffc5c5c5);
  // static var generalTextColorDark = const Color(0xffffffff);

  //Surface
  static var surfaceColorDark = const Color(0xffffffff);
  static var onSurfaceColorDark = const Color(0xff000000);

  //other
  static const iconThemeDark = IconThemeData(color: Colors.white);

  //----------------------------------------------------------------------------

  //Universal
  static const loginButtonTextColor = Colors.black;
  static const profileButtons = Colors.white70;
  static const selectedButton = Colors.white;
  static const unselectedButton = Color(0xFFBDBDBD);


  const AppColors._();
}
