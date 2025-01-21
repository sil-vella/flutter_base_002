import '../managers/module_manager.dart';
import '../managers/hooks_manager.dart';
import '../services/shared_preferences.dart';
import '../managers/state_manager.dart';

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

  /// Access SharedPrefManager globally
  SharedPrefManager get sharedPrefManager => SharedPrefManager();

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
      module.initializeWithPlugin(this); // Pass reference of the plugin to the module
      moduleManager.registerModule(moduleKey, module);
    });
  }

  /// Override to provide initial state for plugin (used by PluginRegistry)
  dynamic getInitialState() => {};

  // ------ State Management Methods ------

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

  // ------ Shared Preferences Methods ------

  /// Save a shared preference for the plugin
  Future<void> setPluginPreference(String key, dynamic value) async {
    final pluginKey = runtimeType.toString();
    final prefixedKey = '$pluginKey:$key';

    if (value is String) {
      await sharedPrefManager.setString(prefixedKey, value);
    } else if (value is int) {
      await sharedPrefManager.setInt(prefixedKey, value);
    } else if (value is bool) {
      await sharedPrefManager.setBool(prefixedKey, value);
    } else if (value is double) {
      await sharedPrefManager.setDouble(prefixedKey, value);
    } else {
      throw Exception('Unsupported value type for SharedPreferences.');
    }
  }

  /// Get a shared preference for the plugin
  dynamic getPluginPreference(String key) {
    final pluginKey = runtimeType.toString();
    final prefixedKey = '$pluginKey:$key';
    return sharedPrefManager.getString(prefixedKey) ??
        sharedPrefManager.getInt(prefixedKey) ??
        sharedPrefManager.getBool(prefixedKey) ??
        sharedPrefManager.getDouble(prefixedKey);
  }

  /// Remove a shared preference for the plugin
  Future<void> removePluginPreference(String key) async {
    final pluginKey = runtimeType.toString();
    final prefixedKey = '$pluginKey:$key';
    await sharedPrefManager.remove(prefixedKey);
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
