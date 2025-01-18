import 'package:shared_preferences/shared_preferences.dart';
import '../../../00_base/module_base.dart';

class SharedPreferencesService extends ModuleBase {
  // Singleton setup
  SharedPreferencesService._internal() {
    _registerSharedPreferencesMethods();
  }

  static final SharedPreferencesService _instance = SharedPreferencesService._internal();
  SharedPreferences? _prefs;

  // Public factory for accessing the singleton instance
  factory SharedPreferencesService() => _instance;

  /// Initialize SharedPreferences once during app startup
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized.');
  }

  /// Registers shared preferences methods dynamically
  void _registerSharedPreferencesMethods() {
    registerMethod('setString', setString);
    registerMethod('setInt', setInt);
    registerMethod('setBool', setBool);
    registerMethod('setDouble', setDouble);

    registerMethod('getString', getString);
    registerMethod('getInt', getInt);
    registerMethod('getBool', getBool);
    registerMethod('getDouble', getDouble);

    registerMethod('remove', remove);
    registerMethod('clear', clear);
  }

  // ------ Setter Methods ------
  Future<void> setString(String key, String value) async => await _prefs?.setString(key, value);
  Future<void> setInt(String key, int value) async => await _prefs?.setInt(key, value);
  Future<void> setBool(String key, bool value) async => await _prefs?.setBool(key, value);
  Future<void> setDouble(String key, double value) async => await _prefs?.setDouble(key, value);

  // ------ Getter Methods ------
  String? getString(String key) => _prefs?.getString(key);
  int? getInt(String key) => _prefs?.getInt(key);
  bool? getBool(String key) => _prefs?.getBool(key);
  double? getDouble(String key) => _prefs?.getDouble(key);

  // ------ Utility Methods ------
  /// Removes a specific key
  Future<void> remove(String key) async => await _prefs?.remove(key);

  /// Clears all preferences (use cautiously)
  Future<void> clear() async => await _prefs?.clear();
}
