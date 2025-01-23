import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/features/screen/calender_page/widget/custome_card.dart';
import 'package:day_task/core/features/screen/calender_page/widget/date_line.dart';
import 'package:day_task/core/features/screen/calender_page/widget/second_custome_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../routing/app_routes.dart';
import '../../../styling/app_assets.dart';
import '../../../widgets/spacing_widgets.dart';

class CalenderPage extends StatefulWidget {
  const CalenderPage({super.key});

  @override
  State<CalenderPage> createState() => _CalenderPageState();
}

class _CalenderPageState extends State<CalenderPage> {
  DateTime _selectedDate = DateTime.now();
  String _selectedMonth = '';
  List<Map<String, dynamic>> projects = [];

  @override
  void initState() {
    super.initState();
    _selectedMonth = _getMonthName(_selectedDate);
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('projects')
            .where('created_at', isEqualTo: user.uid)
            .get();

        List<Map<String, dynamic>> fetchedProjects = [];

        for (var doc in querySnapshot.docs) {
          var data = doc.data() as Map<String, dynamic>;

          if (data.containsKey('dead_line_date') && data.containsKey('dead_line_time')) {
            String projectId = doc.id;
            String deadLineDate = data['dead_line_date'];
            String deadLineTime = data['dead_line_time'];

            fetchedProjects.add({
              'id': projectId,
              'deadLineDate': deadLineDate,
              'deadLineTime': deadLineTime,
            });
          }
        }

        // ترتيب المشاريع حسب التاريخ
        fetchedProjects.sort((a, b) {
          DateTime dateA = parseDateTime(a['deadLineDate'], a['deadLineTime']);
          DateTime dateB = parseDateTime(b['deadLineDate'], b['deadLineTime']);
          return dateA.compareTo(dateB);
        });

        setState(() {
          projects = fetchedProjects;
        });
      } catch (e) {
        print("Error loading projects: $e");
      }
    }
  }

  DateTime parseDateTime(String dateStr, String timeStr) {
    try {
      String dateTimeStr = '$dateStr $timeStr';
      return DateFormat('yyyy-MM-dd HH:mm').parse(dateTimeStr);
    } catch (e) {
      print("Error parsing date time: $e");
      return DateTime.now();
    }
  }

  void _onDateSelected(DateTime selectedDate, String monthName) {
    setState(() {
      _selectedDate = selectedDate;
      _selectedMonth = monthName;
    });
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProjects = projects.where((project) {
      DateTime projectDate =
      parseDateTime(project['deadLineDate'], project['deadLineTime']);
      return projectDate.year == _selectedDate.year &&
          projectDate.month == _selectedDate.month &&
          projectDate.day == _selectedDate.day;
    }).toList();

    List<Map<String, dynamic>> upcomingProjects = projects.where((project) {
      DateTime projectDate =
      parseDateTime(project['deadLineDate'], project['deadLineTime']);
      return projectDate.isAfter(_selectedDate) &&
          !(projectDate.year == _selectedDate.year &&
              projectDate.month == _selectedDate.month &&
              projectDate.day == _selectedDate.day);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => GoRouter.of(context).pushNamed(AppRoutes.mainScreen),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(AppAssets.arrowBackIcon),
          ),
        ),
        title: const Text("Schedule", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 25.w,
            right: 25.w,
            bottom: kBottomNavigationBarHeight,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedMonth,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              HeighSpace(25),
              DateLine(
                initialDate: _selectedDate,
                onDateSelected: _onDateSelected,
              ),
              HeighSpace(13),
              Text("Today’s Tasks",
                  style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              HeighSpace(13),
              if (filteredProjects.isNotEmpty)
                Column(
                  children: filteredProjects.map((project) {
                    return CustomeCard(
                      nameTask: project['id'],
                      deadLine: project['deadLineDate'] +
                          '  ' +
                          project['deadLineTime'],
                    );
                  }).toList(),
                )
              else
                Center(
                  child: Text(
                    "No tasks for the selected date",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              if (upcomingProjects.isNotEmpty)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: upcomingProjects.length,
                  itemBuilder: (context, index) {
                    final project = upcomingProjects[index];
                    return SecondCustomeCard(
                      nameTask: project['id'],
                      deadLine: project['deadLineDate'] +
                          '  ' +
                          project['deadLineTime'],
                    );
                  },
                )
              else
                Center(
                  child: Text(
                    "No upcoming tasks",
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
