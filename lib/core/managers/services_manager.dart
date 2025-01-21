import '../../tools/logging/logger.dart';
import '../00_base/service_base.dart';

class ServicesManager {
  // Singleton instance
  static final ServicesManager _instance = ServicesManager._internal();

  // Factory constructor to return the singleton instance
  factory ServicesManager() => _instance;

  // Internal constructor for singleton
  ServicesManager._internal();

  // Service storage
  final Map<String, ServicesBase> _services = {};

  /// Get all registered services
  Map<String, ServicesBase> getAllServices() => _services;

  /// Register a service
  void registerService(String serviceKey, ServicesBase service) {
    if (_services.containsKey(serviceKey)) {
      throw Exception('Service with key "$serviceKey" is already registered.');
    }
    _services[serviceKey] = service;
    service.initialize();
    Logger().info('Service registered: $serviceKey');
  }

  /// Check if a service is already registered
  bool isServiceRegistered(String serviceKey) {
    return _services.containsKey(serviceKey);
  }

  /// Deregister a service
  void deregisterService(String serviceKey) {
    final service = _services.remove(serviceKey);
    if (service != null) {
      service.dispose();
      Logger().info('Service deregistered and disposed: $serviceKey');
    }
  }

  /// Get a service
  T? getService<T extends ServicesBase>(String serviceKey) {
    Logger().info('Fetching service: $serviceKey');
    return _services[serviceKey] as T?;
  }

  /// Call a service method dynamically
  dynamic callServiceMethod(String serviceKey, String methodName, [dynamic args = const [], Map<String, dynamic>? namedArgs]) {
    final service = _services[serviceKey];
    if (service == null) {
      throw Exception('Service with key "$serviceKey" not found.');
    }
    return service.callServiceMethod(methodName, args, namedArgs);
  }

  /// Dispose all services
  void dispose() {
    Logger().info('Disposing all services.');
    for (var entry in _services.entries) {
      entry.value.dispose();
      Logger().info('Disposed service: ${entry.key}');
    }
    _services.clear();
    Logger().info('All services have been disposed.');
  }
}
