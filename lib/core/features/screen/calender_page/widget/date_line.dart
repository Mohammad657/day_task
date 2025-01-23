import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateLine extends StatefulWidget {
  final DateTime? initialDate;
  final Function(DateTime, String) onDateSelected; 

  const DateLine({super.key, this.initialDate, required this.onDateSelected});

  @override
  State<DateLine> createState() => _DateLineState();
}

class _DateLineState extends State<DateLine> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _currentDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialDate ?? DateTime.now();
    _selectedDay = _focusedDay;
    _currentDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              if (!isSameDay(selectedDay, _selectedDay)) {
                _selectedDay = selectedDay;
              }
              _focusedDay = focusedDay;
            });

            
            widget.onDateSelected(_selectedDay, _getMonthName(_selectedDay));
          },
          headerStyle: HeaderStyle(
            formatButtonVisible: false,
            titleCentered: false,
            titleTextStyle: TextStyle(fontSize: 0),
            decoration: BoxDecoration(color: Colors.transparent),
            headerMargin: EdgeInsets.zero,
            headerPadding: EdgeInsets.zero,
            leftChevronVisible: false,
            rightChevronVisible: false,
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: Color(0xff263238),
              shape: BoxShape.rectangle,
            ),
            selectedDecoration: BoxDecoration(
              color: Color(0xffFED36A),
              shape: BoxShape.rectangle,
            ),
          ),
          daysOfWeekVisible: false,
          rowHeight: 69.h,
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, events) {
              bool isToday = isSameDay(date, _currentDay);
              bool isSelected = isSameDay(date, _selectedDay);

              return Container(
                width: 44.95.w,
                height: 69.h,
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(0xffFED36A)
                      : isToday
                          ? Color(0xff263238)
                          : Color(0xff263238),
                  shape: BoxShape.rectangle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                     Text(
                      _getDayName(date),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                  ],
                ),
              );
            },
          ),
          availableCalendarFormats: {
            CalendarFormat.week: 'Week',
          },
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.monday,
          weekendDays: [DateTime.sunday],
        ),
      ],
    );
  }

  String _getDayName(DateTime date) {
    List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekDays[date.weekday - 1];
  }

  String _getMonthName(DateTime date) {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[date.month - 1];
  }
}
