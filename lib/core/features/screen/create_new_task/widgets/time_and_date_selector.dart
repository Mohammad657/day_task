import 'package:day_task/core/features/screen/profile_screen/widgets/custome_label_widgets.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TimeAndDateSelector extends StatefulWidget {
  final Function(DateTime date, TimeOfDay time) onTimeAndDateSelected;

  const TimeAndDateSelector({super.key, required this.onTimeAndDateSelected});

  @override
  State<TimeAndDateSelector> createState() => _TimeAndDateSelectorState();
}

class _TimeAndDateSelectorState extends State<TimeAndDateSelector> {
  DateTime selectedDate = DateTime.now(); 
  TimeOfDay selectedTime = TimeOfDay(hour: 11, minute: 0); 

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 41.h,
              width: 41.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.r),
                  color: AppColors.primaryColor),
              child: GestureDetector(
                onTap: () async {
                  DatePicker.showTimePicker(
                    context,
                    showTitleActions: true,
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                    onConfirm: (time) {
                      setState(() {
                        selectedTime = TimeOfDay(hour: time.hour, minute: time.minute);
                        widget.onTimeAndDateSelected(selectedDate, selectedTime); 
                      });
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: SvgPicture.asset(
                    AppAssets.oclockIcon,
                  ),
                ),
              ),
            ),
            CustomeLabelWidgets(
              height: 41.h,
              width: 135.w,
              text: "${selectedTime.format(context)}", 
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: 41.h,
              width: 41.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0.r),
                  color: AppColors.primaryColor),
              child: GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    currentTime: selectedDate,
                    minTime: DateTime(2020, 1, 1),
                    maxTime: DateTime(2030, 12, 31),
                    locale: LocaleType.en,
                    onConfirm: (date) {
                      setState(() {
                        selectedDate = date; 
                        widget.onTimeAndDateSelected(selectedDate, selectedTime); 
                      });
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: SvgPicture.asset(
                    AppAssets.dateIcon,
                  ),
                ),
              ),
            ),
            CustomeLabelWidgets(
              padding: EdgeInsets.zero,
              height: 41.h,
              width: 135.w,
              text: "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}", 
            ),
          ],
        ),
      ],
    );
  }
}
