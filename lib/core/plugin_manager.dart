import '../plugins/00_base/plugin_base.dart';
import 'hooks_manager.dart';
import 'module_manager.dart';

class PluginManager {
  final HooksManager hooksManager = HooksManager();
  final ModuleManager moduleManager = ModuleManager();

  final Map<String, dynamic> _plugins = {};
  final Map<String, dynamic> _pluginStates = {};

  /// Register a plugin and initialize it
  void registerPlugin(String pluginKey, PluginBase plugin) {
    if (_plugins.containsKey(pluginKey)) {
      throw Exception('Plugin with key "$pluginKey" is already registered.');
    }

    _plugins[pluginKey] = plugin;
    print('Plugin registered: $pluginKey');

    // Initialize the plugin
    plugin.initialize();
  }

  /// Deregister a plugin and clean up
  void deregisterPlugin(String pluginKey) {
    final plugin = _plugins.remove(pluginKey);
    if (plugin != null) {
      plugin.dispose();
    }
    _pluginStates.remove(pluginKey);
  }

  /// Get a plugin
  T? getPlugin<T>(String pluginKey) {
    return _plugins[pluginKey] as T?;
  }

  /// Get plugin state
  T? getPluginState<T>(String pluginKey) {
    return _pluginStates[pluginKey] as T?;
  }

  /// Update plugin state
  void updatePluginState(String pluginKey, dynamic newState) {
    if (_pluginStates.containsKey(pluginKey)) {
      _pluginStates[pluginKey] = newState;
    }
  }
}
