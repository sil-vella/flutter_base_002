
import '../../core/module_manager.dart';
import '../../core/hooks_manager.dart';
import '../../utils/consts/config.dart';
import '../00_base/plugin_base.dart';
import 'modules/connections_module/connections_module.dart';

class MainPlugin extends PluginBase {
  MainPlugin(HooksManager hooksManager, ModuleManager moduleManager)
      : super(hooksManager, moduleManager) {
    // Add modules to the module map
    moduleMap.addAll({
      'connection_module': () => ConnectionsModule(Config.apiUrl),
    });

    // Add hooks to the hook map
    hookMap.addAll({
      'app_startup': () => () {
        print('PluginExample: app_startup hook triggered.');
      },
      'user_logged_in': () => () {
        print('PluginExample: user_logged_in hook triggered.');
      },
    });
  }

  @override
  void initialize() {
    super.initialize();
    print('PluginExample initialized.');
  }

  @override
  void dispose() {
    print('PluginExample disposed.');
    super.dispose();
  }

  @override
  dynamic getInitialState() {
    return {'status': 'initialized', 'data': {}};
  }
}
