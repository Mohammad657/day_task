import 'package:day_task/core/features/screen/main_screen/widgets/custom_app_bar_home.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/custome_card_list_view.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/custome_carosel_widget.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/search_bar_home.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/primary_text_button_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ProjectManagement projectManagement = ProjectManagement();
  late Future<List<Map<String, dynamic>>> projects;

  @override
  void initState() {
    super.initState();
    projects = projectManagement.getAllProjectsForCurrentUser();
  }

  double getCompletionPercentage(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) return 0.0;

    int completedCount = tasks.where((task) => task['subtaskStatus'] == true).length;
    int totalCount = tasks.length;

    return (completedCount / totalCount) * 100;
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Column(
        children: [
          const HeighSpace(28),
          const CustomAppBarHome(),
          const HeighSpace(30),
          const SearchBarHome(),
          const HeighSpace(32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Completed Tasks",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
              PrimaryTextButtonWidget(
                onPressed: () {},
                buttonText: "See all",
                textColor: AppColors.primaryColor,
                fontSize: 16.sp,
              ),
            ],
          ),
          const HeighSpace(10),
          const CustomeCaroselWidget(),
          const HeighSpace(30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ongoing Projects",
                style: TextStyle(color: Colors.white, fontSize: 20.sp),
              ),
              PrimaryTextButtonWidget(
                onPressed: () {},
                buttonText: "See all",
                textColor: AppColors.primaryColor,
                fontSize: 16.sp,
              ),
            ],
          ),
          const HeighSpace(10),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: projects,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      var project = snapshot.data![index];
                      var projectName = project['project_name'];
                      var description = project['description'];
                      var deadLineDate = project['dead_line_date'];

                      return FutureBuilder<List<Map<String, dynamic>>>(
                        future: projectManagement.fetchTasks(projectName),
                        builder: (context, taskSnapshot) {
                          if (taskSnapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (taskSnapshot.hasError) {
                            return Center(child: Text("Error loading tasks"));
                          } else if (taskSnapshot.hasData) {
                            var tasks = taskSnapshot.data!;
                            double progressPercentage = getCompletionPercentage(tasks);

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskDetailScreen(
                                      nameTask: projectName,
                                      projectDetails: description,
                                      deadLineTime: deadLineDate,
                                      cardColor: Colors.white,
                                      progressValue: progressPercentage,
                                      teamMemberImages: [],
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  CustomeCardListView(
                                    nameTask: projectName,
                                    cardColor: Colors.blue,
                                    deadLineTime: deadLineDate,
                                    progressValue: progressPercentage,
                                    textColor: Colors.white,
                                    teamMemberImages: [],
                                  ),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            );
                          } else {
                            return Center(child: Text("No tasks available"));
                          }
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text("No ongoing projects available"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
