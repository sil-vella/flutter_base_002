import 'package:flutter/material.dart';
import '../../00_base/screen_base.dart';

class HomeScreen extends BaseScreen {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  String computeTitle(BuildContext context) {
    // Return a fixed title for the screen
    return "Home";
  }

  @override
  HomeScreenState createState() => HomeScreenState();
}

// Rename _HomeScreenState to HomeScreenState
class HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  Widget buildContent(BuildContext context) {
    return Stack(
      children: [],
    );
  }
}
