typedef HookCallback = void Function();

class HooksManager {
  final Map<String, List<HookCallback>> _hooks = {};

  /// Register a hook for a specific event
  void registerHook(String hookName, HookCallback callback) {
    _hooks.putIfAbsent(hookName, () => []).add(callback);
  }

  /// Trigger all callbacks for a specific hook
  void triggerHook(String hookName) {
    if (_hooks.containsKey(hookName)) {
      for (final callback in _hooks[hookName]!) {
        callback();
      }
    }
  }

  /// Deregister all hooks for a specific event
  void deregisterHook(String hookName) {
    _hooks.remove(hookName);
  }

  /// Deregister a specific callback from a hook
  void deregisterCallback(String hookName, HookCallback callback) {
    _hooks[hookName]?.remove(callback);
    if (_hooks[hookName]?.isEmpty ?? true) {
      _hooks.remove(hookName);
    }
  }
}
