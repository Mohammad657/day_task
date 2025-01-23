import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styling/app_colors.dart';

class PrimaryOutLinedButtonWidget extends StatelessWidget {
  final String? buttonText;
  final double? width;
  final double? height;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  final Color? borderColor;
  final void Function()? onPressed;
  final double? fonstSize;
  final String? iconPath;
  const PrimaryOutLinedButtonWidget(
      {super.key,
      this.buttonText,
      this.width,
      this.height,
      this.borderRadius,
      this.fontSize,
      this.textColor,
      this.onPressed,
      this.fonstSize,
      this.borderColor, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(

        style: ElevatedButton.styleFrom(
          backgroundColor: const Color( 0xFF212832),
          side: BorderSide(
              color: borderColor ?? AppColors.primaryColor, width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 8.r),
          ),
          fixedSize: Size(width ?? 376.w, height ?? 67.h),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath ?? ""
            ),
            const WidthSpace(12),
            Text(
              buttonText ?? "",
              style: TextStyle(
                  color: textColor ?? AppColors.primaryColor,
                  fontSize: fonstSize ?? 20.sp,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }
}
