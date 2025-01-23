import 'package:flutter/material.dart';
import 'package:day_task/core/routing/router_generation_config.dart';

class AppInitializer extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  const AppInitializer({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RouterGenerationConfig.initializeRouter(), 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error initializing the router: ${snapshot.error}'),
              ),
            ),
          );
        }
        return builder(context);
      },
    );
  }
}
