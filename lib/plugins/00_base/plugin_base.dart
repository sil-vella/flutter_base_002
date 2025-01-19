import 'package:flush_me_im_famous/core/navigation_manager.dart';
import '../../core/module_manager.dart';
import '../../core/hooks_manager.dart';

abstract class PluginBase {
  final HooksManager hooksManager;
  final ModuleManager moduleManager;

  /// Map for modules
  final Map<String, Function> moduleMap = {};

  /// Map for hooks
  final Map<String, HookCallback> hookMap = {}; // Add hookMap

  PluginBase(this.hooksManager, this.moduleManager);

  /// Register modules dynamically from the moduleMap
  void registerModules() {
    moduleMap.forEach((moduleKey, createModule) {
      final module = createModule();
      moduleManager.registerModule(moduleKey, module);
      print('Module registered: $moduleKey'); // Log module registration
    });
  }

  /// Register hooks dynamically from the hookMap
  void registerHooks() {
    hookMap.forEach((hookName, callback) {
      print('Registering hook: $hookName');
      hooksManager.registerHook(hookName, callback); // Register hooks
    });
  }

  /// Initialize the plugin
  void initialize() {
    registerModules();
    registerHooks(); // Ensure hooks are registered
  }

  /// Dispose the plugin
  void dispose() {
    // Deregister modules
    moduleMap.keys.forEach(moduleManager.deregisterModule);
    // Deregister hooks
    hookMap.keys.forEach(hooksManager.deregisterHook);
  }

  /// Get initial state (can be overridden by plugins)
  dynamic getInitialState() => {};
}
