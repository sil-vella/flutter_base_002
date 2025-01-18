import '../../core/hooks_manager.dart';
import '../../core/module_manager.dart';

abstract class PluginBase {
  final HooksManager hooksManager;
  final ModuleManager moduleManager;

  /// Map for modules
  final Map<String, Function> moduleMap = {};

  /// Map for hooks
  final Map<String, Function> hookMap = {};

  PluginBase(this.hooksManager, this.moduleManager);

  /// Register hooks dynamically from the hookMap
  void registerHooks() {
    hookMap.forEach((hookName, callback) {
      hooksManager.registerHook(hookName, callback());
    });
  }

  /// Register modules dynamically from the moduleMap
  void registerModules() {
    moduleMap.forEach((moduleKey, createModule) {
      moduleManager.registerModule(moduleKey, createModule());
    });
  }

  /// Initialize the plugin
  void initialize() {
    registerHooks();
    registerModules();
  }

  /// Dispose the plugin
  void dispose() {
    // Deregister hooks
    hookMap.keys.forEach(hooksManager.deregisterHook);

    // Deregister modules
    moduleMap.keys.forEach(moduleManager.deregisterModule);
  }

  /// Get initial state (can be overridden by plugins)
  dynamic getInitialState() => {};
}
