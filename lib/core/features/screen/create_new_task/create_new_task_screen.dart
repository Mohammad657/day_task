import 'package:day_task/core/features/screen/create_new_task/widgets/time_and_date_selector.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/widgets/primary_button_widget.dart';
import 'package:day_task/core/widgets/primary_text_field_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreateNewTaskScreen extends StatefulWidget {
  const CreateNewTaskScreen({super.key});

  @override
  State<CreateNewTaskScreen> createState() => _CreateNewTaskScreenState();
}

class _CreateNewTaskScreenState extends State<CreateNewTaskScreen> {
  ProjectManagement projectManagement = ProjectManagement();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final TextEditingController taskName = TextEditingController();
  final TextEditingController taskDetails = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: InkWell(
          onTap: () => GoRouter.of(context).pushNamed(AppRoutes.mainScreen),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(AppAssets.arrowBackIcon),
          ),
        ),
        title: const Text(
          "Create New Task",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 41.w, right: 29.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Task Title",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            const HeighSpace(9),
            PrimaryTextFieldWidget(
              controller: taskName,
              width: 358.w,
              height: 48.h,
              hintText: "Hi-Fi Wireframe",
              textColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 40.w,
              ),
            ),
            HeighSpace(25),
            Text(
              "Task Details",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            const HeighSpace(10),
            PrimaryTextFieldWidget(
              controller: taskDetails,
              fontSize: 11.sp,
              textColor: Colors.white,
              width: 358.w,
              height: 82.h,
              hintText:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
              contentPadding: EdgeInsets.symmetric(
                horizontal: 40.w,
              ),
            ),
            HeighSpace(25),
            Text(
              "Time & Date",
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            TimeAndDateSelector(
              onTimeAndDateSelected: (DateTime date, TimeOfDay time) {
                setState(() {
                  selectedDate = date;
                  selectedTime = time;
                });
              },
            ),
            HeighSpace(100),
            PrimaryButtonWidget(
              onPressed: () async {
                if (selectedDate != null && selectedTime != null) {
                  String projectName = taskName.text;
                  String description = taskDetails.text;
                  String idUnique = "id_${DateTime.now().millisecondsSinceEpoch}";
                  await projectManagement.addProject(
                    projectName,
                    description,
                    selectedDate!,
                    selectedTime!,
                    idUnique,
                    tasks,
                  );
                  GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select both date and time')),
                  );
                }
              },
              buttonText: "Create",
              textColor: Colors.black,
              fontSize: 18.sp,
              height: 67.h,
              width: 358.w,
            ),
          ],
        ),
      ),
    );
  }
}
