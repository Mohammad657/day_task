import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/styling/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CustomeAppBarTaskDetails extends StatelessWidget {
  const CustomeAppBarTaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
      GoRouter.of(context).pushReplacement(AppRoutes.mainScreen);

          } ,
          child: SvgPicture.asset(
            AppAssets.arrowBackIcon,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        Text(
          "Task Details",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            AppAssets.editIcon,
            colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
      ],
    );
  }
}
