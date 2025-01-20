import 'package:flutter/material.dart';
import '../tools/logging/logger.dart';
import 'plugin_manager.dart';
import 'module_manager.dart';
import 'hooks_manager.dart';
import 'plugin_registry.dart';
import 'navigation_manager.dart';

class AppManager extends ChangeNotifier {
  static final AppManager _instance = AppManager._internal();

  final NavigationContainer navigationContainer;
  final PluginManager pluginManager;
  final ModuleManager moduleManager;
  final HooksManager hooksManager;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // Factory to always return the singleton instance
  factory AppManager(NavigationContainer navigationContainer, HooksManager hooksManager) {
    if (!_instance._isInitialized) {
      _instance._initializePlugins();
    }
    return _instance;
  }

  // Internal constructor for singleton
  AppManager._internal()
      : navigationContainer = NavigationContainer(),
        hooksManager = HooksManager(),
        pluginManager = PluginManager(HooksManager()),
        moduleManager = ModuleManager();

  void triggerHook(String hookName) {
    hooksManager.triggerHook(hookName);
  }

  void _initializePlugins() async {
    final plugins = PluginRegistry.getPlugins(pluginManager, navigationContainer);
    for (var entry in plugins.entries) {
      pluginManager.registerPlugin(entry.key, entry.value);
    }

    hooksManager.triggerHook('app_startup');
    hooksManager.triggerHook('reg_nav');
    _isInitialized = true;
    notifyListeners();
  }

  void _disposeApp() {
    moduleManager.dispose();
    pluginManager.dispose();
    notifyListeners();
  }
}
