import 'package:flutter/material.dart';

class NavigationContainer extends ChangeNotifier {
  // Singleton instance
  static final NavigationContainer _instance = NavigationContainer._internal();

  factory NavigationContainer() {
    return _instance;
  }

  NavigationContainer._internal();

  final Map<String, WidgetBuilder> _routes = {};
  final List<DrawerItem> _drawerItems = [];

  // Getters
  Map<String, WidgetBuilder> get routes => _routes;
  List<DrawerItem> get drawerItems => _drawerItems;

  // Register a new route
  void registerRoute(String route, WidgetBuilder builder) {
    _routes[route] = builder;
    notifyListeners(); // Notify listeners of changes
  }

  // Register a new navigation item
  void registerNavItem(DrawerItem item) {
    _drawerItems.add(item);
    notifyListeners(); // Notify listeners of changes
  }
}

class DrawerItem {
  final String label;
  final String route;
  final IconData icon;

  DrawerItem({
    required this.label,
    required this.route,
    required this.icon,
  });
}
