import 'package:flush_me_im_famous/plugins/main_plugin/main_plugin_main.dart';
import '../tools/logging/logger.dart';
import 'plugin_manager.dart';
import 'navigation_manager.dart';

class PluginRegistry {
  static final Map<String, dynamic> _pluginInstances = {};

  static Map<String, dynamic> getPlugins(PluginManager pluginManager, NavigationContainer navigationContainer) {
    if (_pluginInstances.isEmpty) {
      _pluginInstances.addAll({
        'main_plugin': MainPlugin(
          pluginManager.hooksManager,
          pluginManager.moduleManager,
          navigationContainer,
        ),
      });
      Logger().info('Plugins registered in PluginRegistry: ${_pluginInstances.keys}');
    } else {
      Logger().info('Plugins already registered. Skipping re-registration.');
    }

    return _pluginInstances;
  }
}
