import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_task/core/routing/app_routes.dart';
import 'package:day_task/core/widgets/primary_out_line_button_widget.dart';
import 'package:day_task/core/widgets/spacing_widgets.dart';
import 'package:day_task/firebase/project_managment.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../styling/app_assets.dart';
import '../../../widgets/primary_button_widget.dart';
import '../../../widgets/primary_text_field_widget.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool isPassword = false;
  bool isChecked = false;
  ProjectManagement projectManagement = ProjectManagement();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signup() async {
    try {
      String username = _usernameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      if (username.isEmpty || email.isEmpty || password.isEmpty) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Error'),
            content: Text('Please enter username, email, and password.'),
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

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,

      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': username,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      GoRouter.of(context).pushNamed(AppRoutes.mainScreen);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'The email is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Signup Failed'),
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
              "Create your account",
              style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const HeighSpace(17),
            Text(
              "Full Name",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff8CAAB9)),
            ),
            const HeighSpace(5),
            PrimaryTextFieldWidget(
              controller: _usernameController,
              prefexIcon: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  AppAssets.personIcon,
                ),
              ),
              hintText: "Full Name",
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
            const HeighSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      isChecked = !isChecked;
                    });
                  },
                  child: SvgPicture.asset(
                    isChecked ? AppAssets.tickIcon : AppAssets.tickSquareeIcon,
                    colorFilter: const ColorFilter.mode(
                      Color(0xffFED36A),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                RichText(
                    text: TextSpan(
                        text: "I have read & agreed to DayTask Privacy ",
                        style: TextStyle(
                            color: const Color(0xff8CAAB9),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.sp),
                        children: [
                      TextSpan(
                        text: "Policy,\nTerms & Condition",
                        style: TextStyle(
                            color: const Color(0xffFED36A),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            GoRouter.of(context)
                                .pushNamed(AppRoutes.splashScreen);
                          },
                      )
                    ])),
              ],
            ),
            const HeighSpace(25),
            PrimaryButtonWidget(
              onPressed: signup,
              buttonText: "Sign Up",
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
                      text: "Already have an account? ",
                      style: TextStyle(
                          color: const Color(0xff8CAAB9),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                      children: [
                    TextSpan(
                      text: "Log In",
                      style: TextStyle(
                          color: const Color(0xffFED36A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          GoRouter.of(context)
                              .pushNamed(AppRoutes.loginScreen);
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
