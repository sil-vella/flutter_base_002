import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../tools/logging/logger.dart';
import '../00_base/service_base.dart';
import '../managers/services_manager.dart'; // Import ServicesManager

class SharedPrefManager extends ServicesBase {
  // Singleton setup
  SharedPrefManager._internal();

  static final SharedPrefManager _instance = SharedPrefManager._internal();
  SharedPreferences? _prefs;

  // Public factory for accessing the singleton instance
  factory SharedPrefManager() {
    _instance._registerWithManager(); // Register with ServicesManager
    return _instance;
  }

  /// Register the service with ServicesManager
  void _registerWithManager() {
    final servicesManager = ServicesManager();
    if (!servicesManager.isServiceRegistered('shared_pref')) {
      servicesManager.registerService('shared_pref', this);
      Logger().info('SharedPrefManager registered with ServicesManager.');
    }
  }

  @override
  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    Logger().info('SharedPreferences initialized.');

    // Register methods to ServicesBase
    registerServiceMethod('setString', setString);
    registerServiceMethod('setInt', setInt);
    registerServiceMethod('setBool', setBool);
    registerServiceMethod('setDouble', setDouble);

    registerServiceMethod('getString', getString);
    registerServiceMethod('getInt', getInt);
    registerServiceMethod('getBool', getBool);
    registerServiceMethod('getDouble', getDouble);

    registerServiceMethod('remove', remove);
    registerServiceMethod('clear', clear);
  }

  // ------ Setter Methods ------
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
    Logger().info('Set String: $key = $value');
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
    Logger().info('Set Int: $key = $value');
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
    Logger().info('Set Bool: $key = $value');
  }

  Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
    Logger().info('Set Double: $key = $value');
  }

  // ------ Getter Methods ------
  String? getString(String key) => _prefs?.getString(key);
  int? getInt(String key) => _prefs?.getInt(key);
  bool? getBool(String key) => _prefs?.getBool(key);
  double? getDouble(String key) => _prefs?.getDouble(key);

  // ------ Utility Methods ------
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
    Logger().info('Removed key: $key');
  }

  Future<void> clear() async {
    await _prefs?.clear();
    Logger().info('Cleared all preferences');
  }

  @override
  void dispose() {
    super.dispose();
    Logger().info('SharedPrefManager disposed.');
  }
}
