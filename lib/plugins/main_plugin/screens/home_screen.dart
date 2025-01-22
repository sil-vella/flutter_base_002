import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:provider/provider.dart';
import '../../../core/00_base/screen_base.dart';
import '../../../core/managers/state_manager.dart';
import '../../../core/managers/module_manager.dart';
import '../../../core/managers/app_manager.dart';

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
  final TextEditingController _usernameController = TextEditingController();

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
    _usernameController.dispose();
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

  Future<void> _saveUsername(String username) async {
    final appManager = AppManager();
    final sharedPref = appManager.servicesManager.getService('shared_pref');
    if (sharedPref != null) {
      await sharedPref.callServiceMethod('setString', ['username', username]);
      debugPrint('Username saved: $username');
    } else {
      debugPrint('SharedPrefManager not available.');
    }
  }

  @override
  Widget buildContent(BuildContext context) {
    // Retrieve AnimationsModule using ModuleManager
    final animationsModule = ModuleManager().getModule('animations_module');

    if (animationsModule == null) {
      return const Center(
        child: Text("Required modules are not available."),
      );
    }

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the main app state
              Text(
                'App State: ',
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

              // Text field to input username
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Username',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Button to save username
              ElevatedButton(
                onPressed: () {
                  final username = _usernameController.text;
                  if (username.isNotEmpty) {
                    _saveUsername(username);
                  } else {
                    debugPrint('Username cannot be empty.');
                  }
                },
                child: const Text('Save Username'),
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

