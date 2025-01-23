import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/custome_app_bar_task_details.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/task_card_details.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/core/widgets/primary_button_widget.dart';
import 'package:day_task/core/widgets/primary_text_field_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TaskDetailScreen extends StatefulWidget {
  final String nameTask;
  final Color cardColor;
  final String deadLineTime;
  final double progressValue;
  final String projectDetails;
  final List<String> teamMemberImages;

  TaskDetailScreen({
    Key? key,
    required this.nameTask,
    required this.cardColor,
    required this.deadLineTime,
    required this.progressValue,
    required this.projectDetails,
    required this.teamMemberImages,
  }) : super(key: key);

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController newTask = TextEditingController();
  ProjectManagement projectManagement = ProjectManagement();
  List<Map<String, dynamic>> tasks = [];

  Future<void> _loadTasks() async {
    try {
      List<Map<String, dynamic>> fetchedTasks =
          await projectManagement.fetchTasks(widget.nameTask);

      setState(() {
        tasks = fetchedTasks;
      });
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  @override
  void initState() {
    _loadTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double percentage = projectManagement.getCompletionPercentage(tasks);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 29.w, left: 29.w, top: 37.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomeAppBarTaskDetails(),
                const HeighSpace(50),
                Text(
                  "${widget.nameTask}",
                  style: TextStyle(
                    fontSize: 19.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "pilat",
                  ),
                ),
                const HeighSpace(25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 47.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.r),
                              color: AppColors.primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: SvgPicture.asset(
                              AppAssets.calendarDeadLineIcon,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xff263238), BlendMode.srcIn),
                            ),
                          ),
                        ),
                        const WidthSpace(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Due Date",
                                style: TextStyle(
                                    color: const Color(0xff8CAAB9),
                                    fontSize: 15.sp)),
                            Text(
                              "${widget.deadLineTime}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          height: 47.h,
                          width: 47.w,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.r),
                              color: AppColors.primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.all(11.0),
                            child: SvgPicture.asset(
                              AppAssets.peopleTeam,
                              colorFilter: const ColorFilter.mode(
                                  Color(0xff263238), BlendMode.srcIn),
                            ),
                          ),
                        ),
                        const WidthSpace(15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Project Team",
                                style: TextStyle(
                                    color: const Color(0xff8CAAB9),
                                    fontSize: 15.sp)),
                            Row(
                              children: widget.teamMemberImages
                                  .map((image) {
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
                                  })
                                  .take(3)
                                  .toList(),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                const HeighSpace(30),
                Text(
                  "Project Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 21.5.sp,
                      fontWeight: FontWeight.w500),
                ),
                const HeighSpace(10),
                Text(
                  "${widget.projectDetails}",
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: const Color(0xffBCCFD8),
                    fontSize: 18.5.sp,
                  ),
                ),
                const SizedBox(height: 13),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Project Progress",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.5.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 59.w,
                          height: 59.h,
                          child: CircularProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: const Color(0xff2C4653),
                            color: AppColors.primaryColor,
                            strokeWidth: 3,
                            semanticsLabel: 'Circular progress indicator',
                          ),
                        ),
                        Text(
                          '${percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                HeighSpace(38),
                Text(
                  "All Tasks",
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      "No tasks available",
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      var isCompleted = task['subtaskStatus'] ?? false;
                      var taskName = task['taskName'] ?? 'Unnamed Task';

                      return TaskCardDetails(
                        taskName: taskName,
                        isCompleted: isCompleted,
                        colorFilter: ColorFilter.mode(
                          isCompleted ? Colors.black : AppColors.greyColor,
                          BlendMode.srcIn,
                        ),
                        onToggleCompletion: () async {
                          try {
                            setState(() {
                              tasks[index]['subtaskStatus'] = !isCompleted;
                            });

                            await FirebaseFirestore.instance
                                .collection('projects')
                                .doc(widget.nameTask)
                                .update({
                              'tasks': tasks,
                            });
                          } catch (e) {
                            print('Error updating task status: $e');
                          }
                        },
                      );
                    },
                  ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 114.h,
            color: Color(0xff263238),
            child: Center(
              child: PrimaryButtonWidget(
                width: 318.w,
                height: 57.h,
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: Color(0xff263238),
                        content: Container(
                          width: 350.w,
                          height: 200.h,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              PrimaryTextFieldWidget(
                                controller: newTask,
                                hintText: "Task Name",
                              ),
                              SizedBox(height: 16.h),
                              PrimaryButtonWidget(
                                width: 318.w,
                                height: 57.h,
                                onPressed: () async {
                                  String taskId =
                                      'task1${DateTime.now().millisecondsSinceEpoch}';
                                  String taskName = newTask.text;
                                  bool subtaskStatus = false;

                                  await projectManagement.addTaskToProject(
                                    widget.nameTask,
                                    taskId,
                                    taskName,
                                    subtaskStatus,
                                  );

                                  Navigator.pop(context);
                                  newTask.clear();

                                  await _loadTasks();
                                },
                                buttonText: "Save",
                                textColor: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                buttonText: "Add Task",
                textColor: Colors.black,
                fontSize: 18.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
