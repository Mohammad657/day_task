import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../styling/app_colors.dart';

class SecondCustomeCard extends StatelessWidget {
  final String? nameTask;
  final String? deadLine;
  const SecondCustomeCard({super.key, this.nameTask, this.deadLine});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Row(
        
          children: [
            Container(
              color: AppColors.primaryColor,
              width: 11.w,
              height: 72.h,
            ),
            Container(
              color: Color(0xff263238),
              width: 359.w,
              height: 72.h,
              padding: EdgeInsets.only(top: 7.h, bottom: 7.h, left: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nameTask ?? "",
                      style: TextStyle(
                          fontSize: 22.sp,
                          color: Colors.white)),
                  Text(deadLine ?? "",
                      style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
        HeighSpace(10)
      ],
    );
  }
}
