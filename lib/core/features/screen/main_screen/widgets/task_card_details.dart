import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskCardDetails extends StatelessWidget {
  final String taskName; 
  final bool isCompleted; 
  final VoidCallback onToggleCompletion; 
final String? iconPath;
final ColorFilter? colorFilter;
  const TaskCardDetails({
    super.key,
    required this.taskName,
    required this.isCompleted,
    required this.onToggleCompletion, this.iconPath, this.colorFilter,
  });

  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 17.w,
            right: 10.w,
          ),
          color: Color(0xff455A64),
          width: 370.w,
          height: 58.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                taskName,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: onToggleCompletion, 
                child: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.r),
                      color: AppColors.primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SvgPicture.asset(
                     iconPath ?? AppAssets.checkIcon,
                      colorFilter: colorFilter,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        HeighSpace(12)
      ],
    );
  }
}
