import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styling/app_colors.dart';
import '../styling/app_fonts.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
    final Color? iconColor;

  final void Function()? onPressed;
  final String? fontFamily;
  final String? iconPath; 

  const PrimaryButtonWidget({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.width,
    this.height,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.onPressed,
    this.fontFamily,
    this.iconPath, this.iconColor, 
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor ?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
        ),
        fixedSize: Size(width ?? 364.w, height ?? 54.h),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            SvgPicture.asset(
              iconPath!,
              width: 30.w,
              height: 30.h,
              colorFilter: ColorFilter.mode(iconColor ?? Colors.white, BlendMode.srcIn),
            ),
          if (iconPath != null) SizedBox(width: 8.w), 
          Text(
            buttonText ?? "",
            style: TextStyle(
              color: textColor ?? Colors.black,
              fontSize: fontSize ?? 16.sp,
              fontFamily: fontFamily ?? AppFonts.mainFontName,
            ),
          ),
        ],
      ),
    );
  }
}
