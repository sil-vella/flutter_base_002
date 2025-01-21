import 'package:flush_me_im_famous/core/managers/plugin_manager.dart';
import 'package:flutter/material.dart';
import '../../plugins/plugin_registry.dart';
import '../services/shared_preferences.dart';
import 'hooks_manager.dart';
import 'module_manager.dart';
import 'navigation_manager.dart';
import 'services_manager.dart';

class AppManager extends ChangeNotifier {
  static final AppManager _instance = AppManager._internal();

  final NavigationContainer navigationContainer;
  final PluginManager pluginManager;
  final ModuleManager moduleManager;
  final HooksManager hooksManager;
  final ServicesManager servicesManager; // Add ServicesManager

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
        moduleManager = ModuleManager(),
        servicesManager = ServicesManager(); // Initialize ServicesManager

  /// Initializes app-wide services
  /// Initializes app-wide services
  Future<void> _initializeServices() async {
    // Fetch all self-registered services and initialize them
    final registeredServices = servicesManager.getAllServices();
    for (var service in registeredServices.values) {
      await service.initialize();
    }

    debugPrint('App services initialized successfully.');
  }


  /// Trigger hooks dynamically
  void triggerHook(String hookName) {
    hooksManager.triggerHook(hookName);
  }

  /// Initializes plugins and services
  Future<void> _initializePlugins() async {
    await _initializeServices(); // Initialize services first

    final plugins = PluginRegistry.getPlugins(pluginManager, navigationContainer);
    for (var entry in plugins.entries) {
      pluginManager.registerPlugin(entry.key, entry.value);
    }

    hooksManager.triggerHook('app_startup');
    hooksManager.triggerHook('reg_nav');
    _isInitialized = true;
    notifyListeners();
  }

  /// Cleans up app resources
  void _disposeApp() {
    moduleManager.dispose();
    pluginManager.dispose();
    servicesManager.dispose(); // Dispose services
    notifyListeners();
    debugPrint('App resources disposed successfully.');
  }
}
