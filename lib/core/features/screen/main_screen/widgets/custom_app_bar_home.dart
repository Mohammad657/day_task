import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:day_task/firebase/user_profile_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CustomAppBarHome extends StatefulWidget {
  const CustomAppBarHome({super.key});

  @override
  State<CustomAppBarHome> createState() => _CustomAppBarHomeState();
}

class _CustomAppBarHomeState extends State<CustomAppBarHome> {



  final UserProfileService _userProfileService = UserProfileService();
  String? _downloadUrl;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    await _userProfileService.getCurrentUser();
    String? downloadUrl = await _userProfileService.getImageFromFirebase();
    if (mounted) {
      setState(() {
        _downloadUrl = downloadUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      await _userProfileService.pickAndUploadImage();
      _loadUserProfile(); 
    } catch (e) {
      print("خطأ: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }




  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back!" ,style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500, color: AppColors.primaryColor,)
            ),
            Text(
              "Fazil Laghari" ,style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w500, color:Colors.white, fontFamily: "pilat")
            ),
          ],
        ),
         SizedBox(
          width: 45,
          height: 45,
           child: InkWell(
            onTap:   (){
              GoRouter.of(context).pushNamed(AppRoutes.profileScreen);
            }    ,
             child: ClipOval(
                    child:   _downloadUrl != null
                  ? Image.network(_downloadUrl!)
                  : Text('لا توجد صورة'),
                  ),
           ),
         ),

      ],
    );
  }
}