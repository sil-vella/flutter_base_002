import 'package:flush_me_im_famous/plugins/main_plugin/main_plugin_main.dart';
import 'plugin_manager.dart';

class PluginRegistry {
  /// Map of plugin keys to their constructors
  static final Map<String, Function(PluginManager)> _plugins = {
    'main_plugin': (pluginManager) => MainPlugin(
      pluginManager.hooksManager,
      pluginManager.moduleManager,
    ),

    // Add more plugins here as needed
  };

  /// Retrieve all plugins
  static Map<String, dynamic> getPlugins(PluginManager pluginManager) {
    return _plugins.map((key, constructor) => MapEntry(key, constructor(pluginManager)));
  }
}
