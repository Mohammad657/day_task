import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/features/screen/profile_screen/widgets/avatar_with_add.dart';
import 'package:day_task/core/features/screen/profile_screen/widgets/custome_label_widgets.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/widgets/primary_button_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class PrfileScreen extends StatefulWidget {
  const PrfileScreen({super.key});

  @override
  State<PrfileScreen> createState() => _PrfileScreenState();
}

class _PrfileScreenState extends State<PrfileScreen> {
  String? name; // Nullable string initialized to null by default
  String? email;
  bool isEditname = true;
  bool isEditEmail = true;
  bool isEditPassword = true;
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            name = userData['username'] ?? 'No Name';
            email = userData['email'] ?? 'No Email';
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // تسجيل الخروج
      GoRouter.of(context).pushReplacementNamed(AppRoutes.splashScreen); // إعادة التوجيه إلى شاشة تسجيل الدخول
    } catch (e) {
      print("Error signing out: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to log out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => GoRouter.of(context).pushNamed(AppRoutes.mainScreen),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: SvgPicture.asset(AppAssets.arrowBackIcon),
          ),
        ),
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            const HeighSpace(30),
            AvatarWithAdd(),
            const HeighSpace(50),
            CustomeLabelWidgets(
              isEdit: isEditname,
              prefixIcon: AppAssets.profilePersonIcon,
              text: name ?? 'Loading...',
              onTap: () {},
            ),
            const HeighSpace(18),
            CustomeLabelWidgets(
              isEdit: isEditEmail,
              prefixIcon: AppAssets.personOutLine,
              text: email ?? 'Loading...',
              onTap: () {},
            ),
            const HeighSpace(18),
            CustomeLabelWidgets(
              prefixIcon: AppAssets.allTaskIcon,
              suffixIcon: AppAssets.arrowDownIcon,
              text: "My Tasks",
              onTap: () {},
            ),
            const HeighSpace(18),
            CustomeLabelWidgets(
              prefixIcon: AppAssets.privacyIcon,
              suffixIcon: AppAssets.arrowDownIcon,
              text: "Privacy",
              onTap: () {},
            ),
            const Spacer(),
            PrimaryButtonWidget(
              onPressed: _signOut, // استدعاء دالة تسجيل الخروج
              buttonText: "Logout",
              fontSize: 18.sp,
              iconPath: AppAssets.logOutIcon,
              iconColor: Colors.black,
            ),
            const HeighSpace(18),
          ],
        ),
      ),
    );
  }
}
