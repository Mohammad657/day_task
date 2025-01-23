import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeCard extends StatefulWidget {
  final String nameTask;
  final Color? cardColor;
  final Color? textColor;
  final double? progressValue;

  const CustomeCard({
    super.key,
    required this.nameTask,
    this.cardColor,
    this.textColor,
    this.progressValue,
  });

  @override
  State<CustomeCard> createState() => _CustomeCardState();
}

class _CustomeCardState extends State<CustomeCard> {
  @override
  Widget build(BuildContext context) {
    Color cardColor = widget.cardColor ?? AppColors.primaryColor;

    Color themeColor =
        cardColor == AppColors.primaryColor ? Colors.black : Colors.white;
    return Stack(
      children: [
        Container(
          width: 183.w,
          height: 175.h,
          decoration: BoxDecoration(
            color: widget.cardColor ?? AppColors.primaryColor,
            borderRadius: BorderRadius.circular(0.r),
          ),
        ),
        Positioned(
          width: 183.w,
          left: 10.w,
          top: 7.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(
                  widget.nameTask,
                  style: TextStyle(
                      color: themeColor,
                      fontFamily: "pilat",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
              const HeighSpace(13),
              Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Team members",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: themeColor,
                        )),
                    Container(
                      child: Row(
                        children: [
                          Align(
                              widthFactor: 0.6,
                              child: ClipOval(
                                  child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(AppAssets.profileImage),
                              ))),
                          Align(
                              widthFactor: 0.6,
                              child: ClipOval(
                                  child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(AppAssets.profileImage),
                              ))),
                          Align(
                              widthFactor: 0.6,
                              child: ClipOval(
                                  child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(AppAssets.profileImage),
                              ))),
                          Align(
                              widthFactor: 0.6,
                              child: ClipOval(
                                  child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(AppAssets.profileImage),
                              ))),
                          Align(
                              widthFactor: 0.6,
                              child: ClipOval(
                                  child: SizedBox(
                                width: 20.w,
                                height: 20.h,
                                child: Image.asset(AppAssets.profileImage),
                              ))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const HeighSpace(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Completed",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: themeColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      "%100",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: themeColor,
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(
                width: 163.w,
                child: LinearProgressIndicator(
                  value: (widget.progressValue ?? 100) / 100,
                  borderRadius: BorderRadius.circular(10),
                  color: themeColor,
                  backgroundColor: themeColor,
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
