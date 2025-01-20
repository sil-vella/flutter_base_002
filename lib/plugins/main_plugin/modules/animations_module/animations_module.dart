import 'package:flutter/material.dart';
import '../../../../core/00_base/module_base.dart';
import '../../../../tools/logging/logger.dart'; // Ensure Logger is imported

class AnimationsModule extends ModuleBase {
  static AnimationsModule? _instance;

  AnimationsModule._internal() {
    Logger().info('AnimationsModule instance created.');
    _registerAnimationMethods();
  }

  /// Factory method to provide the singleton instance
  factory AnimationsModule() {
    if (_instance == null) {
      Logger().info('Initializing AnimationsModule for the first time.');
      _instance = AnimationsModule._internal();
    } else {
      Logger().info('AnimationsModule instance already exists.');
    }
    return _instance!;
  }

  /// Registers animation methods with the module
  void _registerAnimationMethods() {
    Logger().info('Registering animation methods in AnimationsModule.');
    registerMethod('applyFadeAnimation', applyFadeAnimation);
    registerMethod('applyScaleAnimation', applyScaleAnimation);
    registerMethod('applySlideAnimation', applySlideAnimation);
    Logger().info('Animation methods registered successfully.');
  }

  /// Applies fade animation to the provided widget
  Widget applyFadeAnimation({
    required Widget child,
    required AnimationController controller,
    required Duration duration,
  }) {
    Logger().info('Applying fade animation.');
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Opacity(
          opacity: controller.value,
          child: child,
        );
      },
    );
  }

  /// Applies scale animation to the provided widget
  Widget applyScaleAnimation({
    required Widget child,
    required AnimationController controller,
    required Duration duration,
    double begin = 0.8,
    double end = 1.2,
  }) {
    Logger().info('Applying scale animation.');
    final scaleAnimation = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    return AnimatedBuilder(
      animation: scaleAnimation,
      builder: (context, _) {
        return Transform.scale(
          scale: scaleAnimation.value,
          child: child,
        );
      },
    );
  }

  /// Applies slide animation to the provided widget
  Widget applySlideAnimation({
    required Widget child,
    required AnimationController controller,
    required Duration duration,
    Offset begin = const Offset(0, -1),
    Offset end = const Offset(0, 0),
  }) {
    Logger().info('Applying slide animation.');
    final slideAnimation = Tween<Offset>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
    return AnimatedBuilder(
      animation: slideAnimation,
      builder: (context, _) {
        return SlideTransition(
          position: slideAnimation,
          child: child,
        );
      },
    );
  }
}
