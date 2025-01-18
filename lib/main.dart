import 'package:flush_me_im_famous/plugins/main_plugin/modules/navigation_module/navigation_container.dart';
import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
import 'package:flush_me_im_famous/utils/consts/theme_consts.dart';
import 'package:flush_me_im_famous/utils/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_manager.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager()),
        ChangeNotifierProvider(create: (context) => NavigationContainer()),
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

    // Trigger the app_startup hook
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appManager = Provider.of<AppManager>(context, listen: false);
      appManager.triggerHook('app_startup');
    });
  }

  @override
  Widget build(BuildContext context) {
    final navigationContainer = Provider.of<NavigationContainer>(context, listen: false);

    return MaterialApp(
      title: Config.appTitle,
      navigatorKey: NavigationContainer.navigatorKey,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
      onGenerateRoute: navigationContainer.generateRoute,
    );
  }
}
