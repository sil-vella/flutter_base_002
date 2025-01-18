import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({Key? key}) : super(key: key);

  /// Define a method to compute the title dynamically
  String computeTitle(BuildContext context);

  @override
  BaseScreenState createState();
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, navigationContainer, child) {

        return Scaffold(
          appBar: AppBar(
            // Dynamically compute the title using the widget's computeTitle method
            title: Text(widget.computeTitle(context)),
            actions: [
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: buildContent(context), // Main content of the screen
              ),
            ],
          ),
        );
      },
    );
  }

  /// Abstract method to be implemented in subclasses
  Widget buildContent(BuildContext context);
}
