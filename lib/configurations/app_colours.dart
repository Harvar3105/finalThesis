import 'package:flutter/material.dart';

@immutable
class AppColors {

  //Light mode
  static const backgroundColorLight = Color(0xffffffff);
  static const primaryColorLight = appColor;
  static const secondaryColorLight = Color(0xffd9d9d9);

  //Text
  static const primaryTextColorLight = Color(0xff000000);
  static const secondaryTextColorLight = Color(0xff2c2c2c);
  // static const generalTextColorLight = const Color(0xff000000);

  //Surface
  static const surfaceColorLight = Color(0xffd1d1d1);
  static const onSurfaceColorLight = Color(0xff000000);

  //other
  static const iconThemeLight = Colors.black;

  //----------------------------------------------------------------------------

  //Dark mode
  static const backgroundColorDark = Color(0xff273342);
  static const primaryColorDark = appColor;
  static const secondaryColorDark = Color(0xff737373);

  //Text
  static const primaryTextColorDark = Color(0xffffffff);
  static const secondaryTextColorDark = Color(0xffc5c5c5);
  // static const generalTextColorDark = const Color(0xffffffff);

  //Surface
  static const surfaceColorDark = Color(0xff505050);
  static const onSurfaceColorDark = Color(0xff000000);

  //other
  static const iconThemeDark = Colors.white;

  //----------------------------------------------------------------------------

  //Universal
  static const loginButtonTextColor = Colors.black;
  static const profileButtons = Colors.white70;
  static const selectedButton = Colors.white;
  static const unselectedButton = Color(0xFFBDBDBD);
  static const appColor = Color(0xFF9B3AFF);


  const AppColors._();
}
