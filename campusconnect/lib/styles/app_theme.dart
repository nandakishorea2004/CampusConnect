import 'package:campus/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class AppTheme{


  static final appThemeConfig =ThemeData(
  primarySwatch: Colors.blue,
  fontFamily: "Poppins",
  scaffoldBackgroundColor:HexColor("#F1F2F5"),
  iconTheme: const IconThemeData(
  color: Colors.black, size: 18,
  shadows: <Shadow>[Shadow(color: Colors.black, blurRadius: 0.5)],
  ),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: AppColors.primaryColor,
      filled: true,
      labelStyle: const TextStyle(fontFamily: "Poppins"),
      prefixIconColor: AppColors.appPrimaryColor,
      suffixIconColor: AppColors.appPrimaryColor,

      hintStyle:   TextStyle(fontSize: 14, fontWeight: FontWeight.w600, fontStyle: FontStyle.normal,
          color: AppColors.greyColor  ),
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide:  BorderSide(width: 1.0, color: AppColors.borderColor, )),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide:  BorderSide(width: 1.0, color: AppColors.borderColor,)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0),
          borderSide:  BorderSide(width: 1.0, color: AppColors.borderColor)),
    ),
    appBarTheme: AppBarTheme(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: AppColors.appPrimaryColor,

        //shadowColor: AppColors.appBarShadowColor,
        iconTheme: IconThemeData(
            color: AppColors.greyColor,
            size: 18
        ),
        actionsIconTheme: IconThemeData(
            color: AppColors.greyColor,
            size: 24
        ),
        titleTextStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.primaryColor)

    ),
  );
}