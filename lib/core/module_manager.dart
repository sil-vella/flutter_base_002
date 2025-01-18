import '../plugins/00_base/module_base.dart';

class ModuleManager {
  final Map<String, ModuleBase> _modules = {};

  /// Register a module
  void registerModule(String moduleKey, ModuleBase module) {
    if (_modules.containsKey(moduleKey)) {
      throw Exception('Module with key "$moduleKey" is already registered.');
    }

    _modules[moduleKey] = module;

    // Log the module registration
    print('Module registered: $moduleKey');
  }

  /// Deregister a module
  void deregisterModule(String moduleKey) {
    if (_modules.remove(moduleKey) != null) {
      print('Module deregistered: $moduleKey');
    }
  }

  /// Get a module
  T? getModule<T extends ModuleBase>(String moduleKey) {
    return _modules[moduleKey] as T?;
  }

  /// Call a method on a module
  dynamic callModuleMethod(String moduleKey, String methodName, [dynamic args]) {
    final module = _modules[moduleKey];
    if (module != null) {
      return module.callMethod(methodName, args);
    }
    throw Exception('Module or method not found: $moduleKey -> $methodName');
  }

  /// Log all registered modules
  void logRegisteredModules() {
    if (_modules.isEmpty) {
      print('No modules are currently registered.');
    } else {
      print('Registered modules:');
      _modules.keys.forEach((moduleKey) {
        print('- $moduleKey');
      });
    }
  }
}
