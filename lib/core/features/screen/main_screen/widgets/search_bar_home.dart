import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/primary_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class SearchBarHome extends StatelessWidget {
  const SearchBarHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrimaryTextFieldWidget(
            width: 311.w,
              prefexIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  AppAssets.searchIcon,
                ),
              ),
              hintText: "Seach tasks",
            ),
            Container(
                  height: 58.h,
                  width: 57.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.r),
                      color: AppColors.primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: SvgPicture.asset(
                      AppAssets.searchIcon,
                      colorFilter:
                          const ColorFilter.mode(Color(0xff263238), BlendMode.srcIn),
                    ),
                  ),
                ),
        ],
      );
  }
}