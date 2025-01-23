import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextButtonWidget extends StatelessWidget {
  final String? buttonText;
  final Color? buttonColor;
  final double? fontSize;
  final Color? textColor;
  final TextDecoration? decoration;
  final void Function()? onPressed;
  final TextAlign? textAlign;
  final AlignmentGeometry? alignment;
  const PrimaryTextButtonWidget({
    super.key,
    this.buttonText,
    this.buttonColor,
    this.fontSize,
    this.textColor,
    this.decoration,
    this.onPressed, 
    this.textAlign, this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.centerLeft,
      child: TextButton(
          onPressed: onPressed,
          child: Text(
            buttonText ?? "",
            textAlign: textAlign,
            style: TextStyle(
              
              decoration: decoration ?? TextDecoration.none,
              color: textColor ?? const Color(0xff202955),
              fontSize: fontSize ?? 15.sp,
            ),
          )),
    );
  }
}
