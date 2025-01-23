import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrimaryTextFieldWidget extends StatelessWidget {
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefexIcon;
  final double? height;
  final double? width;
  final double? borderRadius;
  final double? fontSize;
  final Color? textColor;
  final Color? borderColor;
  final bool? isPassword;
  final EdgeInsetsGeometry? contentPadding;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  const PrimaryTextFieldWidget({
    super.key,
    this.hintText,
    this.suffixIcon,
    this.borderRadius,
    this.fontSize,
    this.textColor,
    this.borderColor,
    this.isPassword,
    this.controller,
    this.validator,
    this.prefexIcon,
    this.height,
    this.width,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 58.h,
      width: width ?? 376.w,
              decoration: BoxDecoration(
                color: Color(0xff455A64),
     ),
      child: TextFormField(
  maxLines:  (isPassword ?? false) ? 1 : null,

        controller: controller,
        validator: validator,
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        obscureText: isPassword ?? false,
        decoration: InputDecoration(
          hintText: hintText ?? "",
          hintStyle: TextStyle(
            color: textColor ?? Colors.white30,
            fontSize: fontSize ?? 18.sp,
          ),
          suffixIcon: suffixIcon,
          prefixIcon: prefexIcon,
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(horizontal: 40.w, vertical: 19.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 0.r),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.w,
            ),
          ),
          filled: true,
          fillColor: const Color(0xff455A64),
        ),
      ),
    );
  }
}
