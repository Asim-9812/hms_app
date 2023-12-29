import 'package:flutter/material.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/core/resources/value_manager.dart';

import 'color_manager.dart';
import 'font_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors of the app
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.primaryOpacity80,
    primaryColorDark: ColorManager.primaryDark,
    disabledColor: ColorManager
        .dotGrey, // will be used incase of disabled button for example

    // card view theme
    cardTheme: CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.blackOpacity25,
      elevation: AppSize.s4,
    ),

    // App bar theme
    appBarTheme: AppBarTheme(
      centerTitle: true,
      color: ColorManager.white,
      elevation: AppSize.s4,
      shadowColor: ColorManager.blackOpacity25,
      titleTextStyle:
          getRegularStyle(color: ColorManager.white, fontSize: FontSize.s26),
    ),

    // elevated Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        textStyle: getRegularStyle(color: ColorManager.white),
        backgroundColor: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.s18),
        ),
      ),
    ),

    // Text theme
    // textTheme: TextTheme(
    //   headline1:
    //       getBoldStyle(color: ColorManager.white, fontSize: FontSize.s24),
    //   headline2:
    //       getBoldStyle(color: ColorManager.white, fontSize: FontSize.s20),
    //   headline3:
    //       getSemiBoldStyle(color: ColorManager.white, fontSize: FontSize.s20),
    //   subtitle1: getMediumStyle(
    //       color: ColorManager.subtitleGrey, fontSize: FontSize.s26),
    //   subtitle2: getRegularStyle(
    //       color: ColorManager.subtitleGrey, fontSize: FontSize.s26),
    //   caption: getRegularStyle(color: ColorManager.black),
    //   bodyText1: getRegularStyle(color: ColorManager.black),
    // ),

    // input decoration theme (text form field)
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p14),
      // hint style
      hintStyle: getRegularStyle(color: ColorManager.textGrey),

      // label style
      labelStyle: getMediumStyle(color: ColorManager.textGrey),
      // error style
      errorStyle: getRegularStyle(color: ColorManager.red),

      // enabled border
      enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s15))),

      // focused border
      focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s15))),

      // error border
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.red, width: AppSize.s1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s15))),
      // focused error border
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorManager.red, width: AppSize.s1_5),
        borderRadius: BorderRadius.all(Radius.circular(AppSize.s15)),
      ),
    ),
  );
}
