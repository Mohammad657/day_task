import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/widgets/primary_out_line_button_widget.dart';
import 'package:day_task/core/widgets/primary_text_button_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../styling/app_assets.dart';
import '../../../widgets/primary_button_widget.dart';
import '../../../widgets/primary_text_field_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassword = false;
  ProjectManagement projectManagement = ProjectManagement();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> login() async {
    try {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter both email and password.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }


      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Logged in as ${userCredential.user?.email}");
      GoRouter.of(context).pushNamed(AppRoutes.mainScreen);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Login Failed'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 26.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeighSpace(30),
            Center(
              child: SvgPicture.asset(
                AppAssets.iconSvg,
                height: 91.92.h,
                width: 139.w,
              ),
            ),
            const HeighSpace(30),
            Text(
              "Welcome Back!",
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const HeighSpace(18),
            Text(
              "Email Address",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff8CAAB9)),
            ),
            const HeighSpace(5),
            PrimaryTextFieldWidget(
              controller: _emailController,
              prefexIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  AppAssets.emailIcon,
                ),
              ),
              hintText: "Email",
            ),
            const HeighSpace(20),
            Text(
              "Password",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff8CAAB9)),
            ),
            const HeighSpace(5),
            PrimaryTextFieldWidget(
              controller: _passwordController,
              isPassword: isPassword,
              prefexIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  AppAssets.passwordIcon,
                ),
              ),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isPassword = !isPassword;
                    });
                  },
                  icon: SvgPicture.asset(
                    isPassword ? AppAssets.eyeSlashIcon : AppAssets.eyeIcon,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  )),
              hintText: "Password",
            ),
            PrimaryTextButtonWidget(
              onPressed: () {},
              buttonText: "Forgot Password?",
              alignment: Alignment.centerRight,
              textColor: const Color(0xff8CAAB9),
            ),
            const HeighSpace(25),
            PrimaryButtonWidget(
              onPressed: login,
              buttonText: "Log In",
              textColor: Colors.black,
              fontSize: 18.sp,
            ),
            const HeighSpace(30),
            Row(
              children: [
                SizedBox(
                  width: 111.w,
                  child: const Divider(),
                ),
                const WidthSpace(13),
                Text("Or continue with",
                    style: TextStyle(
                        fontSize: 16.sp, color: const Color(0xff8CAAB9))),
                const WidthSpace(13),
                SizedBox(
                  width: 111.w,
                  child: const Divider(),
                ),
              ],
            ),
            const HeighSpace(30),
            PrimaryOutLinedButtonWidget(
              iconPath: AppAssets.googleIcon,
              buttonText: "Google",
              onPressed: () =>projectManagement.signInWithGoogle(context),
              textColor: Colors.white,
              fontSize: 18.sp,
              borderRadius: 0,
            ),
            const HeighSpace(18),
            Center(
              child: RichText(
                  text: TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(
                          color: const Color(0xff8CAAB9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                      children: [
                    TextSpan(
                      text: "Sign Up",
                      style: TextStyle(
                          color: const Color(0xffFED36A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context)
                              .pushNamed(AppRoutes.createAccountScreen);
                        },
                    )
                  ])),
            ),
          ],
        ),
      ),
    );
  }
}
