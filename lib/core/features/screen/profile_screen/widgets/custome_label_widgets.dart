import 'package:day_task/core/widgets/primary_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomeLabelWidgets extends StatelessWidget {
  final String? text;
  final String? prefixIcon;
  final String? suffixIcon;
  final Function()? onTap;
  final double? width;
  final double? height;
  final bool? isEdit;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? padding;
  const CustomeLabelWidgets({
    super.key,
    this.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.width,
    this.height,
    this.padding,
    this.isEdit,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return (isEdit ?? true)
        ? Container(
            width: width ?? 364.w,
            height: height ?? 54.h,
            padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Color(0xff455A64),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (prefixIcon != null)
                  SvgPicture.asset(
                    prefixIcon ?? "",
                    width: 30.w,
                    height: 30.w,
                  ),
                SizedBox(width: 8),
                Text(
                  text ?? "",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Spacer(),
                if (suffixIcon != null)
                  GestureDetector(
                    onTap: onTap,
                    child: SvgPicture.asset(
                      suffixIcon ?? "",
                      width: 30.w,
                      height: 30.w,
                    ),
                  ),
              ],
            ),
          )
        : PrimaryTextFieldWidget(
            controller: controller,
            width: width ?? 364.w,
            height: height ?? 54.h,
            suffixIcon: GestureDetector(
              onTap: onTap,
              child: Padding(
                padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
                child: Icon(
                  Icons.check,
                  color: const Color(0xff8CAAB9),
                  size: 30.w,
                ),
              ),
            ),
            prefexIcon: prefixIcon != null
                ? Padding(
                    padding: padding ?? EdgeInsets.symmetric(horizontal: 20.w),
                    child: SvgPicture.asset(
                      prefixIcon ?? "",
                      width: 30.w,
                      height: 30.w,
                    ),
                  )
                : null,
          );
  }
}
