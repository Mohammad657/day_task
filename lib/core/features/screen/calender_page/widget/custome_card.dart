import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeCard extends StatelessWidget {
  final String? nameTask;
  final String? deadLine;
  const CustomeCard({super.key, this.nameTask, this.deadLine});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.primaryColor,
          width: 375.w,
          height: 72.h,
          padding: EdgeInsets.only(top: 7.h, bottom: 7.h, left: 35.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameTask ?? "",
                style: TextStyle(fontSize: 22.sp, color: Colors.black),
              ),
              Text(
                deadLine ?? "",
                style: TextStyle(fontSize: 16.sp, color: Colors.black),
              ),
            ],
          ),
        
        ),
        HeighSpace(10)
      ],
    );
  }
}
