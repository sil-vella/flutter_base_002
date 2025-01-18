typedef HookCallback = void Function();

class HooksManager {
  final Map<String, List<HookCallback>> _hooks = {};

  void registerHook(String hookName, HookCallback callback) {
    print('Registering hook: $hookName');
    _hooks.putIfAbsent(hookName, () => []).add(callback);
    print('Current hooks: $_hooks'); // Log hooks to verify registration
  }


  void triggerHook(String hookName) {
    if (_hooks.containsKey(hookName)) {
      print('Triggering hook: $hookName with ${_hooks[hookName]!.length} callbacks');
      for (final callback in _hooks[hookName]!) {
        print('Executing callback for hook: $hookName');
        callback();
      }
    } else {
      print('No callbacks registered for hook: $hookName');
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
