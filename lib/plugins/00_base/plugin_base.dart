import 'package:flush_me_im_famous/core/navigation_manager.dart';

import '../../core/module_manager.dart';
import '../../core/hooks_manager.dart';

abstract class PluginBase {
  final HooksManager hooksManager;
  final ModuleManager moduleManager;

  /// Map for modules
  final Map<String, Function> moduleMap = {};

  PluginBase(this.hooksManager, this.moduleManager);


  /// Register modules dynamically from the moduleMap
  void registerModules() {
    moduleMap.forEach((moduleKey, createModule) {
      final module = createModule();
      moduleManager.registerModule(moduleKey, module);
      print('Module registered: $moduleKey'); // Log module registration
    });
  }

  /// Initialize the plugin
  void initialize() {
    registerModules();
  }

  /// Dispose the plugin
  void dispose() {
    // Deregister modules
    moduleMap.keys.forEach(moduleManager.deregisterModule);
  }

  /// Get initial state (can be overridden by plugins)
  dynamic getInitialState() => {};
}
