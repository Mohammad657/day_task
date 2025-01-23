// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:untitled1/core/styling/app_colors.dart';
//
// class PrimaryIconWidgets extends StatelessWidget {
//   final AlignmentGeometry? alignment;
//   final double? width;
//   final double? height;
//   final Function()? onPressed;
//   final String iconPath;
//   final double? iconWidth;
//   final double? iconHeight;
//   final double? raduius;
//   final Color? borderColor;
//   final bool? shapActive;
//
//   final Color? bgIcon;
//   const PrimaryIconWidgets({
//     super.key,
//     this.alignment,
//     this.onPressed,
//     this.width,
//     this.height,
//     required this.iconPath,
//     this.iconWidth,
//     this.iconHeight,
//     this.raduius,
//     this.borderColor,
//     this.shapActive = false,
//     this.bgIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: alignment ?? Alignment.centerLeft,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           shape: shapActive == true ? BoxShape.circle : BoxShape.rectangle,
//           color:  Colors.transparent,
//           borderRadius: shapActive == true
//               ? null
//               : BorderRadius.circular(raduius ?? 16.r),
//           border: Border.all(color: borderColor ?? const Color(0xffE8ECF4)),
//         ),
//         child: IconButton(
//           onPressed: onPressed,
//           icon: SvgPicture.asset(
//             iconPath,
//             colorFilter: ColorFilter.mode(
//                 bgIcon ?? AppColors.primaryColor, BlendMode.srcIn),
//             width: iconWidth,
//             height: iconHeight,
//           ),
//         ),
//       ),
//     );
//   }
// }
