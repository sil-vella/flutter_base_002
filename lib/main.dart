import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
import 'package:flush_me_im_famous/utils/consts/theme_consts.dart';
import 'package:flush_me_im_famous/utils/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/app_manager.dart';
import 'core/navigation_manager.dart';

void main() {
  final navContainer = NavigationContainer();

  navContainer.registerRoute('/', (context) => HomeScreen());
  navContainer.registerNavItem(DrawerItem(label: 'Home', route: '/', icon: Icons.home));

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppManager()), // Existing AppManager
        ChangeNotifierProvider(create: (_) => NavigationContainer()), // Updated NavigationContainer
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

    return MaterialApp(
      title: Config.appTitle,
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
