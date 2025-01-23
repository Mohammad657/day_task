import 'package:day_task/core/features/screen/splash_screen.dart';
import 'package:day_task/core/features/screen/auth_screen/create_account.dart';
import 'package:day_task/core/features/screen/auth_screen/login_screen.dart';
import 'package:day_task/core/features/screen/chat_screen/private_chat/create_chat.dart';
import 'package:day_task/core/features/screen/main_screen/home_screen.dart';
import 'package:day_task/core/features/screen/main_screen.dart';
import 'package:day_task/core/features/screen/profile_screen/prfile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class RouterGenerationConfig {
  static GoRouter? _goRouter;

  static Future<void> initializeRouter() async {
    final user = FirebaseAuth.instance.currentUser;

    final initialLocation =
        user == null ? AppRoutes.splashScreen : AppRoutes.mainScreen;

    _goRouter = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: AppRoutes.splashScreen,
          name: AppRoutes.splashScreen,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: AppRoutes.loginScreen,
          name: AppRoutes.loginScreen,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: AppRoutes.createAccountScreen,
          name: AppRoutes.createAccountScreen,
          builder: (context, state) => const CreateAccount(),
        ),
        GoRoute(
          path: AppRoutes.homeScreen,
          name: AppRoutes.homeScreen,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.mainScreen,
          name: AppRoutes.mainScreen,
          builder: (context, state) => const MainScreen(),
        ),
        GoRoute(
          path: AppRoutes.profileScreen,
          name: AppRoutes.profileScreen,
          builder: (context, state) => const PrfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.createChatPage,
          name: AppRoutes.createChatPage,
          builder: (context, state) => CreateChatPage(),
        ),
      ],
    );
  }

  static GoRouter get router {
    if (_goRouter == null) {
      throw Exception("Router not initialized. Call initializeRouter first.");
    }
    return _goRouter!;
  }
}
