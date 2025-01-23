import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'app_colors.dart';
import 'app_fonts.dart';

class AppStyles {
  static TextStyle primaryHeadLinesStyle = TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 30.sp,
      fontWeight: FontWeight.bold,
      color: AppColors.primaryColor);

  static TextStyle subtitlesStyle = TextStyle(
      fontFamily: AppFonts.mainFontName,
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryColor);

  static TextStyle black16W500 = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 16.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.blackColor,
  );
  static TextStyle grey12MediumStyles = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.greyColor,
  );
  static TextStyle black15BoldStyle = TextStyle(
    fontFamily: AppFonts.mainFontName,
    fontSize: 15.sp,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );
}
