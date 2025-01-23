import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';





class ProjectManagement {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<void> addProject(String projectName, String description, DateTime deadlineDate, TimeOfDay deadlineTime, String idUnique, List<Map<String, dynamic>> tasks) async {
   final user = FirebaseAuth.instance.currentUser;
   try {
    String formattedDate = DateFormat('yyyy-MM-dd').format(deadlineDate);

    Map<String, dynamic> projectData = {
      'description': description,
      'dead_line_date': formattedDate,
      'dead_line_time': '${deadlineTime.hour}:${deadlineTime.minute.toString().padLeft(2, '0')}',
      'id_unique': idUnique,
      'tasks': tasks,
      'created_at': user?.uid ?? 'unknown',
    };

    DocumentReference projectDoc = _firestore.collection('projects').doc(projectName);
    await projectDoc.set(projectData);
    print("Project added successfully!");
  } catch (e) {
    print("Error adding project: $e");
  }
}

Future<List<Map<String, dynamic>>> getAllProjectsForCurrentUser() async{
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final name = user.displayName;
    final email = user.email;
    final uid = user.uid;
  }
  try {
    if (user != null && FirebaseAuth.instance.currentUser?.uid == user.uid) {
      QuerySnapshot snapshot = await _firestore
          .collection('projects')
          .where('created_at', isEqualTo: user.uid)
          .get();

      List<Map<String, dynamic>> projectList = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> projectData = {
          'project_name': doc.id,
          'description': doc['description'],
          'dead_line_date': (doc['dead_line_date']),
          'dead_line_time': doc['dead_line_time'],
        };
        projectList.add(projectData);
      }

      return projectList;
    }
  } catch (e) {
    print("Error getting projects for current user: $e");
  }
  return [];
}

  Future<List<Map<String, dynamic>>> getAllProjects() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        final name = user.displayName;
        final email = user.email;
        final uid = user.uid;
      }
      QuerySnapshot snapshot = await _firestore.collection('projects').get();

      List<Map<String, dynamic>> projectList = [];

      for (var doc in snapshot.docs) {
        Map<String, dynamic> projectData = {
          'project_name': doc.id,
          'description': doc['description'],
          'dead_line_date': (doc['dead_line_date']),
          'dead_line_time': doc['dead_line_time'],
          'created_at': user?.uid ?? 'unknown',
        };
        projectList.add(projectData);
      }

      return projectList;
    } catch (e) {
      print("Error getting projects: $e");
      return [];
    }
  }

Future<void> addTaskToProject(
  String projectName, 
  String taskId, 
  String taskName, 
  bool subtaskStatus
) async {
  try {
    DocumentSnapshot projectDoc = await FirebaseFirestore.instance
        .collection('projects')
        .doc(projectName)  
        .get();

    if (projectDoc.exists) {
      var projectData = projectDoc.data() as Map<String, dynamic>;

      Map<String, dynamic> newTask = {
        'taskId': taskId,
        'taskName': taskName,
        'subtaskStatus': subtaskStatus, 
      };

      projectData['tasks'] ??= [];  
      projectData['tasks'].add(newTask);

      await projectDoc.reference.update({
        'tasks': projectData['tasks'],
      });

      print("تم إضافة المهمة بنجاح!");
    } else {
      print("لم يتم العثور على المشروع باستخدام اسم المشروع!");
    }
  } catch (e) {
    print("حدث خطأ أثناء إضافة المهمة: $e");
  }
}


 Future<List<Map<String, dynamic>>> fetchTasks(String projectName) async {
    try {
      var document = await FirebaseFirestore.instance
          .collection('projects')
          .doc(projectName)
          .get();

      if (!document.exists) {
        return [];
      }

      var data = document.data() as Map<String, dynamic>;
      var tasks = data['tasks'] as List<dynamic>?;

      if (tasks == null) {
        return [];
      }

      return tasks.cast<Map<String, dynamic>>();
    } catch (e) {
      throw Exception('Failed to fetch tasks: $e');
    }
  }


double getCompletionPercentage(List<Map<String, dynamic>> tasks) {
  if (tasks.isEmpty) return 0.0;

  int completedCount = tasks.where((task) => task['subtaskStatus'] == true).length;
  int totalCount = tasks.length;

  return (completedCount / totalCount) * 100;
}

  Future<void> updateUserData(Map<String, dynamic> updatedData) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid);
      await userRef.update(updatedData);
    } catch (e) {
      print("Error updating user data: $e");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        
        return;
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        
        final usersCollection = FirebaseFirestore.instance.collection('users');

        
        final userDoc = await usersCollection.doc(user.uid).get();

        if (!userDoc.exists) {
          
          await usersCollection.doc(user.uid).set({
            'username': user.displayName ?? 'No Name', 
            'email': user.email ?? 'No Email',    
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        
        GoRouter.of(context).pushNamed(AppRoutes.mainScreen);
      }
    } on Exception catch (e) {
      print('exception -> $e');
      
    }
  }

  
}

