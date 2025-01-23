import 'package:day_task/core/styling/app_assets.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../routing/app_routes.dart';
import '../../widgets/primary_button_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

        body: Padding(
          padding: EdgeInsets.only(left: 26.w, top: 23.h, right: 26.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeighSpace(10),
              SvgPicture.asset(
                AppAssets.iconSvg,
                height: 62.11.h,
                width: 93.w,
              ),
              const HeighSpace(33),
              SvgPicture.asset(
                AppAssets.splashPic,
                height: 330.h,
                width: 369.w,
              ),
              const HeighSpace(40),
              SvgPicture.asset(
                AppAssets.splashText,
                height: 240.h,
                width: 376.w,
              ),
              const HeighSpace(60),
              PrimaryButtonWidget(
                onPressed: (){
                  GoRouter.of(context).pushNamed(AppRoutes.loginScreen);

                },
                buttonText: "Let’s Start",
                textColor: Colors.black,
                fontSize: 18.sp,
              ),
              const Spacer()
            ],
          ),
        ),

    );
  }
}
