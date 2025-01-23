import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomeCardListView extends StatefulWidget {
  final String nameTask;
  final Color? cardColor;
  final Color? textColor;
  final double? progressValue;
  final String? deadLineTime;
  final List<String> teamMemberImages; 

  const CustomeCardListView( {
    super.key,
    required this.nameTask,
    this.cardColor,
    this.textColor,
    this.progressValue,
    this.deadLineTime,
    required this.teamMemberImages, 
  });

  @override
  State<CustomeCardListView> createState() => _CustomeCardListViewState();
}

class _CustomeCardListViewState extends State<CustomeCardListView> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 384.w,
          height: 125.h,
          decoration: BoxDecoration(
            color: Color(0xff455A64),
            borderRadius: BorderRadius.circular(0.r),
          ),
        ),
        Positioned(
          left: 9.w,
          top: 10.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Text(
                  widget.nameTask,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "pilat",
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp),
                ),
              ),
              const HeighSpace(7),
              Text(
                "Team members",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.white,
                ),
              ),
              HeighSpace(6),
              Padding(
                padding: EdgeInsets.only(left: 6.w),
                child: Row(
                  children: widget.teamMemberImages.map((image) {
                    return Align(
                      widthFactor: 0.6,
                      child: ClipOval(
                        child: SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: Image.asset(image),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              HeighSpace(13),
              Padding(
                padding: EdgeInsets.only(right: 15.w),
                child: Text(
                  "Due on :${widget.deadLineTime}",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          width: 60.w,
          right: 16,
          bottom: 12,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 59,
                height: 59,
                child: CircularProgressIndicator(
                  value: (widget.progressValue ?? 100) / 100,
                  backgroundColor: const Color(0xff2C4653),
                  color: AppColors.primaryColor,
                  strokeWidth: 3,
                  semanticsLabel: 'Circular progress indicator',
                ),
              ),
              Text(
                '${(widget.progressValue ?? 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
