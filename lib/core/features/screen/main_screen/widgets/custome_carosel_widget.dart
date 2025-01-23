import 'package:carousel_slider/carousel_slider.dart';
import 'package:day_task/core/features/screen/main_screen/widgets/custome_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/styling/app_colors.dart';

class CustomeCaroselWidget extends StatefulWidget {
  const CustomeCaroselWidget({super.key});

  @override
  State<CustomeCaroselWidget> createState() => _CustomeCaroselWidgetState();
}

class _CustomeCaroselWidgetState extends State<CustomeCaroselWidget> {
  int currentIndexPage = 0;
  List<Map<String, dynamic>> tasks = [];

  Future<void> _loadCompletedTasks() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final name = user.displayName;
      final email = user.email;
      final uid = user.uid;
    }
    try {
      if (user != null && FirebaseAuth.instance.currentUser?.uid == user.uid) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('projects')
            .where('created_at', isEqualTo: user.uid)
            .get();

        List<Map<String, dynamic>> fetchedProjects = [];

        for (var doc in querySnapshot.docs) {
          print("Project Data: ${doc.data()}");

          List tasksList = doc['tasks'] ?? [];

          print("Tasks for ${doc.id}: $tasksList");

          if (tasksList.isNotEmpty) {
            bool allTasksCompleted = tasksList.every((task) {
              print(
                  "Checking task: ${task['taskName']} - subtaskStatus: ${task['subtaskStatus']}");
              return task['subtaskStatus'] == true;
            });

            if (allTasksCompleted) {
              fetchedProjects.add({
                'projectName': doc.id,
              });
            }
          } else {
            print("Project ${doc.id} has no tasks, skipping.");
          }
        }

        setState(() {
          tasks = fetchedProjects;
        });

        print("Completed Projects: $fetchedProjects");
      }
    } catch (e) {
      print("Error loading tasks: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 175.h,
            padEnds: false,
            viewportFraction: 0.5,
            enlargeCenterPage: true,
            enlargeFactor: 0,
            enableInfiniteScroll: false,
            onPageChanged: (index, reason) {
              setState(() {
                currentIndexPage = index;
              });
            },
          ),
          itemCount: tasks.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            final task = tasks[index];
            return CustomeCard(
              nameTask: task['projectName'],
              cardColor: AppColors.primaryColor,
            );
          },
        ),
      ],
    );
  }
}
