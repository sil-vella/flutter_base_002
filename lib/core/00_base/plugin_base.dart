import 'package:flush_me_im_famous/core/navigation_manager.dart';
import '../../core/module_manager.dart';
import '../../core/hooks_manager.dart';
import '../state_manager.dart';

abstract class PluginBase {
  final HooksManager hooksManager;
  final ModuleManager moduleManager;

  /// Map for modules
  final Map<String, Function> moduleMap = {};

  /// Map for hooks
  final Map<String, HookCallback> hookMap = {}; // Add hookMap

  PluginBase(this.hooksManager, this.moduleManager);

  /// Access StateManager globally
  StateManager get stateManager => StateManager();

  /// Initialize the plugin
  void initialize() {
    registerModules();
    registerHooks(); // Ensure hooks are registered
  }

  /// Register hooks dynamically from the hookMap
  void registerHooks() {
    hookMap.forEach((hookName, callback) {
      hooksManager.registerHook(hookName, callback); // Register hooks
    });
  }

  /// Register modules dynamically from the moduleMap
  void registerModules() {
    moduleMap.forEach((moduleKey, createModule) {
      final module = createModule();
      moduleManager.registerModule(moduleKey, module);
    });
  }

  /// Override to provide initial state for plugin (used by PluginRegistry)
  dynamic getInitialState() => {};

  /// Deregister plugin state
  void deregisterPluginState() {
    final pluginKey = runtimeType.toString();
    stateManager.unregisterPluginState(pluginKey);
  }

  /// Get plugin state
  T? getPluginState<T>() {
    return stateManager.getPluginState<T>(runtimeType.toString());
  }

  /// Update plugin state
  void updatePluginState(Map<String, dynamic> newState) {
    stateManager.updatePluginState(runtimeType.toString(), newState);
  }

  /// Dispose the plugin
  void dispose() {
    // Deregister modules
    moduleMap.keys.forEach(moduleManager.deregisterModule);
    // Deregister hooks
    hookMap.keys.forEach(hooksManager.deregisterHook);

    // Optional: Deregister plugin state
    deregisterPluginState();
  }
}
