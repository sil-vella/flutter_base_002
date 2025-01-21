import 'package:flush_me_im_famous/plugins/main_plugin/main_plugin_main.dart';
import '../tools/logging/logger.dart';
import 'plugin_manager.dart';
import 'navigation_manager.dart';
import 'state_manager.dart';

class PluginRegistry {
  static final Map<String, dynamic> _pluginInstances = {};

  static Map<String, dynamic> getPlugins(
      PluginManager pluginManager,
      NavigationContainer navigationContainer,
      ) {
    if (_pluginInstances.isEmpty) {
      _pluginInstances.addAll({
        // Register plugins here
        'main_plugin': MainPlugin(
          pluginManager.hooksManager,
          pluginManager.moduleManager,
          navigationContainer,
        ),
      });

      // Automatically register plugin states
      _registerPluginStates();

      Logger().info('Plugins registered in PluginRegistry: ${_pluginInstances.keys}');
    } else {
      Logger().info('Plugins already registered. Skipping re-registration.');
    }

    return _pluginInstances;
  }

  /// Automatically register plugin states using StateManager
  static void _registerPluginStates() {
    final stateManager = StateManager(); // Access singleton instance

    for (var entry in _pluginInstances.entries) {
      final pluginKey = entry.value.runtimeType.toString(); // Use runtime type as key
      final plugin = entry.value;

      if (!stateManager.isPluginStateRegistered(pluginKey)) {
        final initialState = (plugin as dynamic).getInitialState();
        stateManager.registerPluginState(pluginKey, initialState);
        Logger().info('Plugin state registered for: $pluginKey');
      }
    }
  }
}
