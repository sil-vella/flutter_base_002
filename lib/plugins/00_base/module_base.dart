abstract class ModuleBase {
  final Map<String, Function> _methodMap = {};

  /// Initialize the module
  void initialize() {
    print('${this.runtimeType} initialized.');
  }

  /// Register a method with a name
  void registerMethod(String methodName, Function method) {
    _methodMap[methodName] = method;
  }

  /// Dynamically call a method by name
  dynamic callMethod(String methodName, [dynamic args]) {
    if (_methodMap.containsKey(methodName)) {
      // Pass arguments to the method if provided
      return Function.apply(_methodMap[methodName]!, args is List ? args : [args]);
    } else {
      throw Exception('Method $methodName not found in ${this.runtimeType}.');
    }
  }
}
