import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
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

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appManager = Provider.of<AppManager>(context, listen: false);
      print('AppManager accessed in widget tree.');

      // Trigger hooks after AppManager is accessed
      appManager.triggerHook('app_startup');
      appManager.triggerHook('reg_nav');
    });
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: Config.appTitle,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
