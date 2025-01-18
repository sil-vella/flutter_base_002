import 'package:flutter/material.dart';
import 'plugin_manager.dart';
import 'module_manager.dart';
import 'hooks_manager.dart';
import 'plugin_registry.dart';

class AppManager extends ChangeNotifier {
  // Overall app state
  String _appState = 'idle';

  /// Managers
  final PluginManager pluginManager;
  final ModuleManager moduleManager;
  final HooksManager hooksManager;

  AppManager()
      : pluginManager = PluginManager(),
        moduleManager = ModuleManager(),
        hooksManager = HooksManager() {
    _initializePlugins();
  }

  /// Getter for app state
  String get appState => _appState;

  /// Setter for app state
  set appState(String newState) {
    _appState = newState;
    notifyListeners();
  }

  /// Trigger a lifecycle hook
  void triggerHook(String hookName) {
    hooksManager.triggerHook(hookName);
  }

  /// Initialize plugins from PluginRegistry
  void _initializePlugins() {
    final plugins = PluginRegistry.getPlugins(pluginManager);

    for (var entry in plugins.entries) {
      pluginManager.registerPlugin(entry.key, entry.value);
    }
  }
}
