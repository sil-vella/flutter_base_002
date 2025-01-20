import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
import 'package:flush_me_im_famous/tools/logging/logger.dart';
import 'package:flush_me_im_famous/utils/consts/theme_consts.dart';
import 'package:flush_me_im_famous/utils/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_manager.dart';
import 'core/hooks_manager.dart';
import 'core/navigation_manager.dart';

void main() {
  final navigationContainer = NavigationContainer();
  final hooksManager = HooksManager(); // Single instance of HooksManager

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager(navigationContainer, hooksManager)),
        ChangeNotifierProvider.value(value: navigationContainer),
      ],
      child: MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppManager>(
      builder: (context, appManager, child) {
        if (!appManager.isInitialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        return MaterialApp(
          title: Config.appTitle,
          theme: AppTheme.darkTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
