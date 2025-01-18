
import 'package:flush_me_im_famous/core/navigation_manager.dart';
import 'package:flush_me_im_famous/plugins/main_plugin/screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../../core/module_manager.dart';
import '../../core/hooks_manager.dart';
import '../../utils/consts/config.dart';
import '../00_base/plugin_base.dart';
import 'modules/connections_module/connections_module.dart';

class MainPlugin extends PluginBase {
  MainPlugin(HooksManager hooksManager, ModuleManager moduleManager, NavigationContainer navigationContainer)
      : super(hooksManager, moduleManager) {
    // Add modules to the module map
    // moduleMap.addAll({
    //   'connection_module': () => ConnectionsModule(Config.apiUrl),
    // });
    // Register hooks directly
    hooksManager.registerHook('app_startup', () {
      print('MainPlugin: app_startup hook triggered.');
    });

    hooksManager.registerHook('user_logged_in', () {
      print('MainPlugin: user_logged_in hook triggered.');
    });

    hooksManager.registerHook('reg_nav', () {
      navigationContainer.registerRoute('/', (context) => HomeScreen());
      navigationContainer.registerNavItem(DrawerItem(
        label: 'Home',
        route: '/',
        icon: Icons.home,
      ));
      print('MainPlugin: Navigation items registered.');
    });
  }

  @override
  void initialize() {
    super.initialize(); // Initialize modules and anything else
  }

  @override
  void dispose() {
    super.dispose(); // Cleanup any resources if necessary
  }

  @override
  dynamic getInitialState() {
    return {'status': 'initialized', 'data': {}};
  }
}