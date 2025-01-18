import 'package:flutter/material.dart';
import 'plugin_manager.dart';
import 'module_manager.dart';
import 'hooks_manager.dart';
import 'plugin_registry.dart';
import 'navigation_manager.dart';

class AppManager extends ChangeNotifier {
  final String _appState = 'idle';
  final NavigationContainer navigationContainer;
  final PluginManager pluginManager;
  final ModuleManager moduleManager;
  final HooksManager hooksManager;

  AppManager(this.navigationContainer, this.hooksManager)
      : pluginManager = PluginManager(hooksManager),
        moduleManager = ModuleManager() {
    print('AppManager initialized.');
    _initializePlugins();
  }

  void triggerHook(String hookName) {
    print('Triggering hook: $hookName');
    hooksManager.triggerHook(hookName);
  }

  void _initializePlugins() {
    final plugins = PluginRegistry.getPlugins(pluginManager, navigationContainer);

    // Register all plugins
    for (var entry in plugins.entries) {
      pluginManager.registerPlugin(entry.key, entry.value);
    }

    print('All plugins initialized.');
  }
}
