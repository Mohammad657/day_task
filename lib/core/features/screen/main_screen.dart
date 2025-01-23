import 'package:day_task/core/features/screen/calender_page/calender_page.dart';
import 'package:day_task/core/features/screen/chat_screen/private_chat/create_chat.dart';
import 'package:day_task/core/features/screen/create_new_task/create_new_task_screen.dart';
import 'package:day_task/core/features/screen/main_screen/home_screen.dart';
import 'package:day_task/core/features/screen/profile_screen/prfile_screen.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/styling/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> screen = [
    const HomeScreen(),
    CreateChatPage(),
CreateNewTaskScreen(),
    CalenderPage(),
       PrfileScreen(),

  ];
  Color getIconColor(int index) {
    return _selectedIndex == index ? AppColors.primaryColor : Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screen[_selectedIndex],
        bottomNavigationBar: SizedBox(
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(color: Color(0xff1F2C37)),
            showSelectedLabels: true,
            
            showUnselectedLabels: true,
            backgroundColor: const Color(0xff263238),
            unselectedLabelStyle: const TextStyle(color: Color(0xff9CA4AB)),
            currentIndex: _selectedIndex,
            onTap: onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.homeIcon,
                  colorFilter:
                      ColorFilter.mode(getIconColor(0), BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.chatIcon,
                  colorFilter:
                      ColorFilter.mode(getIconColor(1), BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  height: 54.h,
                  width: 54.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(0.r),
                      color: AppColors.primaryColor),
                  child: Padding(
                    padding: const EdgeInsets.all(11.0),
                    child: SvgPicture.asset(
                      AppAssets.plusIcon,
                      colorFilter:
                          const ColorFilter.mode(Color(0xff263238), BlendMode.srcIn),
                    ),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.calendarIcon,
                  colorFilter:
                      ColorFilter.mode(getIconColor(3), BlendMode.srcIn),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  AppAssets.profileIcon,
                  colorFilter:
                      ColorFilter.mode(getIconColor(4), BlendMode.srcIn),
                ),
                label: '',
              ),
            ],
          ),
        ));
  }
}
