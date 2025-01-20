import 'package:flutter/material.dart';
import '../../../../core/00_base/module_base.dart';
import '../../../../tools/logging/logger.dart';

class AppStateProvider extends ModuleBase with ChangeNotifier {
  final Map<String, dynamic> _pluginStates = {}; // Stores states for plugins
  Map<String, dynamic> _mainAppState = {'main_state': 'idle'}; // Default main app state

  AppStateProvider() {
    _registerAppStateMethods();
  }

  /// Registers state management methods
  void _registerAppStateMethods() {
    registerMethod('isPluginStateRegistered', isPluginStateRegistered);
    registerMethod('registerPluginState', registerPluginState);
    registerMethod('unregisterPluginState', unregisterPluginState);
    registerMethod('getPluginState', getPluginState);
    registerMethod('updatePluginState', updatePluginState);

    registerMethod('setMainAppState', setMainAppState);
    registerMethod('getMainAppState', getMainAppState);
    registerMethod('updateMainAppState', updateMainAppState);
  }

  // ------ Plugin State Methods ------

  /// Check if a plugin state is registered
  bool isPluginStateRegistered(String pluginKey) {
    return _pluginStates.containsKey(pluginKey);
  }

  /// Register a plugin state dynamically
  void registerPluginState(String pluginKey, dynamic initialState) {
    if (!_pluginStates.containsKey(pluginKey)) {
      _pluginStates[pluginKey] = initialState;
      Logger().info("Registered state for key: $pluginKey"); // Debug log
      notifyListeners();
    }
  }

  /// Unregister a plugin state dynamically
  void unregisterPluginState(String pluginKey) {
    if (_pluginStates.containsKey(pluginKey)) {
      _pluginStates.remove(pluginKey);
      Logger().info("Unregistered state for key: $pluginKey"); // Debug log
      notifyListeners();
    } else {
      Logger().info("No state found for key: $pluginKey to unregister"); // Debug log
    }
  }

  /// Retrieve a plugin state dynamically
  T? getPluginState<T>(String pluginKey) {
    final pluginState = _pluginStates[pluginKey];
    Logger().info("Retrieved state for key: $pluginKey: $pluginState"); // Debug log
    if (pluginState is Map && T == Map<String, dynamic>) {
      return Map<String, dynamic>.from(pluginState) as T;
    }
    return pluginState as T?;
  }

  /// Update a plugin state dynamically
  Future<void> updatePluginState(String pluginKey, Map<String, dynamic> newState) async {
    if (_pluginStates.containsKey(pluginKey)) {
      Logger().info("Existing state for $pluginKey: ${_pluginStates[pluginKey]}");
      _pluginStates[pluginKey] = {
        ..._pluginStates[pluginKey],
        ...newState,
      };
      Logger().info("Updated state for $pluginKey: ${_pluginStates[pluginKey]}");
    } else {
      Logger().info("No existing state for $pluginKey. Creating new state.");
      _pluginStates[pluginKey] = newState; // Create new state
      Logger().info("Created new state for $pluginKey: ${_pluginStates[pluginKey]}");
    }
    notifyListeners();
  }

  // ------ Main App State Methods ------

  /// Set the initial main app state
  void setMainAppState(Map<String, dynamic> initialState) {
    _mainAppState = {'main_state': 'idle', ...initialState};
    Logger().info("Main app state initialized: $_mainAppState"); // Debug log
    notifyListeners();
  }

  /// Get the main app state as a whole
  Map<String, dynamic> get mainAppState => _mainAppState;

  /// Update a specific key-value pair in the main app state
  void updateMainAppState(String key, dynamic value) {
    _mainAppState[key] = value;
    Logger().info("Main app state updated: key=$key, value=$value"); // Debug log
    notifyListeners();
  }

  /// Retrieve a specific value from the main app state
  T? getMainAppState<T>(String key) {
    final value = _mainAppState[key] as T?;
    Logger().info("Retrieved main app state value for key=$key: $value"); // Debug log
    return value;
  }
}
