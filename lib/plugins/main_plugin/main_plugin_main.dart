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
    moduleMap.addAll({
      'connection_module': () => ConnectionsModule(Config.apiUrl),
    });

    // Add hooks directly in hookMap
    hookMap.addAll({
      'app_startup': () {
        print('MainPlugin: app_startup hook triggered.');
      },
      'reg_nav': () {
        navigationContainer.registerRoute('/', (context) => HomeScreen());
        navigationContainer.registerNavItem(DrawerItem(
          label: 'Home',
          route: '/',
          icon: Icons.home,
        ));
        print('MainPlugin: Navigation items registered.');
      },
    });

    print('MainPlugin instance created.');
  }

  @override
  void initialize() {
    super.initialize();
    print('MainPlugin initialized.');
  }

  @override
  void dispose() {
    super.dispose();
    print('MainPlugin disposed.');
  }
}
