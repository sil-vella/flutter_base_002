import 'package:flush_me_im_famous/plugins/main_plugin/main_plugin_main.dart';
import 'plugin_manager.dart';
import 'navigation_manager.dart';

class PluginRegistry {
  /// Map of plugin keys to their constructors
  static Map<String, dynamic> getPlugins(PluginManager pluginManager, NavigationContainer navigationContainer) {
    return {
      'main_plugin': MainPlugin(
        pluginManager.hooksManager,
        pluginManager.moduleManager,
        navigationContainer, // Pass the shared instance
      ),
    };
  }
}
