import 'package:flutter/material.dart';
import '../tools/logging/logger.dart';
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

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  AppManager(this.navigationContainer, this.hooksManager)
      : pluginManager = PluginManager(hooksManager),
        moduleManager = ModuleManager() {
    Logger().info('AppManager initialized.');
    _initializePlugins();
  }

  void triggerHook(String hookName) {
    Logger().info('Triggering hook: $hookName');
    hooksManager.triggerHook(hookName);
  }

  void _initializePlugins() async {
    final plugins = PluginRegistry.getPlugins(pluginManager, navigationContainer);

    for (var entry in plugins.entries) {
      Logger().info('Attempting to register plugin: ${entry.key}');
      pluginManager.registerPlugin(entry.key, entry.value);
    }

    Logger().info('All plugins initialized.');

    // Trigger hooks after initialization
    Logger().info('Triggering app_startup and reg_nav hooks.');
    hooksManager.triggerHook('app_startup');
    hooksManager.triggerHook('reg_nav');

    _isInitialized = true;
    notifyListeners();
  }
}
