import 'package:flush_me_im_famous/core/managers/services_manager.dart';
import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
import 'package:flush_me_im_famous/utils/consts/theme_consts.dart';
import 'package:flush_me_im_famous/utils/consts/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/managers/app_manager.dart';
import 'core/managers/state_manager.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  final appManager = AppManager(); // Instantiate AppManager to access navigationContainer

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => appManager),
        ChangeNotifierProvider(create: (_) => StateManager()),
        ChangeNotifierProvider.value(value: appManager.navigationContainer), // Provide NavigationContainer
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
