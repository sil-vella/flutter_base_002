import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../../core/00_base/screen_base.dart';
import '../../../core/module_manager.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  String computeTitle(BuildContext context) {
    return "Home";
  }

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends BaseScreenState<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildContent(BuildContext context) {
    // Retrieve the AnimationsModule using its key
    final animationsModule = ModuleManager().getModule('animations_module');

    if (animationsModule == null) {
      return const Center(
        child: Text("Animations module not available."),
      );
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated text
              animationsModule.callMethod(
                'applyFadeAnimation',
                [],
                {
                  'child': Text(
                    'Welcome to the Home Screen!',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  'controller': _controller,
                  'duration': const Duration(seconds: 2),
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Trigger the animation
                  if (_controller.isAnimating) {
                    _controller.reset();
                  }
                  _controller.forward();
                },
                child: const Text('Animate Text'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
