import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import '../controller/saved_names_json_controller.dart';// Import the controller

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SavedNamesJsonController _jsonController = SavedNamesJsonController();

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    List<VoidCallback> buttonFunctions = [
          () {
        _jsonController.includeStringInJson(appState.current.asPascalCase);
        print('Function 1 executed!');
      },
          () {
        _jsonController.deleteDataByName(appState.current.asPascalCase);
        print('Function 2 executed!');
      },
          () {
        _jsonController.deleteDataByIndex(0);
        print('Function 3 executed!');
      },
          () async {
        List<String> names = await _jsonController.readJsonAsStrings();
        print(names);
      },
          () {
        _jsonController.deleteEntireJson();
        print('Function 5 executed!');
      },
          () {
        print('Function 6 executed!');
      },
    ];

    List<String> buttonNames = [
      'Add New Name',
      'Delete New Name',
      'Delete at Index 0',
      'Print Saved Names',
      'Delete Entire JSON',
      'Button 6',
    ];

    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height / 10,
              bottom: MediaQuery.of(context).size.height / 20,
            ),
            child: SizedBox(
              child: Center(
                child: Text(
                  'JSON Controller Tester',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 1.5,
              children: List.generate(buttonFunctions.length, (index) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 100,
                  ),
                  child: ElevatedButton(
                    onPressed: buttonFunctions[index],
                    child: Text(buttonNames[index],textAlign: TextAlign.center,),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}