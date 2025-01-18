import 'package:flutter/material.dart';
import 'plugin_manager.dart';
import 'module_manager.dart';
import 'hooks_manager.dart';

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
        hooksManager = HooksManager();

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

  /// Access plugin state via PluginManager
  T? getPluginState<T>(String pluginKey) {
    return pluginManager.getPluginState<T>(pluginKey);
  }

  /// Update plugin state via PluginManager
  void updatePluginState(String pluginKey, dynamic newState) {
    pluginManager.updatePluginState(pluginKey, newState);
    notifyListeners();
  }
}
