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
  String? _testData;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fetchTestData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchTestData() async {
    // Retrieve the ConnectionsModule using its key
    final connectionModule = ModuleManager().getModule('connection_module');

    if (connectionModule == null) {
      setState(() {
        _testData = "Connection module not available.";
      });
      return;
    }

    try {
      // Send a GET request to retrieve test data
      final response = await connectionModule.callMethod(
        'sendGetRequest',
        ['/test-data'], // Replace with your test endpoint
      );
      setState(() {
        _testData = response.toString();
      });
    } catch (e) {
      setState(() {
        _testData = "Failed to fetch test data: $e";
      });
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    // Retrieve the AnimationsModule and AppStateProvider using their keys
    final animationsModule = ModuleManager().getModule('animations_module');
    final appStateProvider = ModuleManager().getModule('app_state_provider_module');

    if (animationsModule == null || appStateProvider == null) {
      return const Center(
        child: Text("Required modules are not available."),
      );
    }

    final appState = appStateProvider.callMethod('getMainAppState', ['main_state']);

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the main app state
              Text(
                'App State: $appState',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Display test data retrieved from the server
              Text(
                _testData ?? "Fetching test data from server...",
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

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

              // Button to trigger animation
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
