import 'dart:developer';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:name_genner/controller/saved_names_json_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

void main() {
  // Initialize the Flutter binding for testing
  TestWidgetsFlutterBinding.ensureInitialized();

  // Mock the getApplicationDocumentsDirectory method
  const MethodChannel channel =
  MethodChannel('plugins.flutter.io/path_provider');

  // Mock the platform channel
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    if (methodCall.method == 'getApplicationDocumentsDirectory') {
      // Create a temporary directory for testing
      final tempDir = await Directory.systemTemp.createTemp();
      return tempDir.path;
    }
    return null;
  });

  // Helper function to setup the test environment
  Future<({Directory appDocDir, SavedNamesJsonController controller})>
  setupTest() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final controller = SavedNamesJsonController();
    final defaultFileName = 'favorited_names.json';
    final backupFileName = 'favorited_names.json.bak';
    // Helper function to backup the file
    Future<void> backupFile() async {
      final originalFile = File(path.join(appDocDir.path, defaultFileName));
      final backupFile = File(path.join(appDocDir.path, backupFileName));

      if (await originalFile.exists()) {
        await originalFile.rename(backupFile.path);
      }
    }

    await backupFile();
    return (appDocDir: appDocDir, controller: controller);
  }

  // Helper function to teardown the test environment
  Future<void> teardownTest(Directory appDocDir) async {
    final defaultFileName = 'favorited_names.json';
    final backupFileName = 'favorited_names.json.bak';
    // Helper function to restore the file
    Future<void> restoreFile() async {
      final originalFile = File(path.join(appDocDir.path, defaultFileName));
      final backupFile = File(path.join(appDocDir.path, backupFileName));

      if (await backupFile.exists()) {
        await backupFile.rename(originalFile.path);
      }
    }

    await restoreFile();
    // Clean up the temp dir
    await appDocDir.delete(recursive: true);
  }

  group('SavedNamesJsonController', () {
    final testString = "Test Name";
    test('File is created when it doesnt exist', () async {
      final (:appDocDir, :controller) = await setupTest();
      final file = File(path.join(appDocDir.path, 'favorited_names.json'));
      expect(await file.exists(), isFalse);
      // File should be empty to start with
      expect(await controller.readJsonAsStrings(), isEmpty);
      await teardownTest(appDocDir);
    });

    test('includeStringInJson adds a string to the JSON file', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      final data = await controller.readJsonAsStrings();
      expect(data, contains(testString));
      await teardownTest(appDocDir);
    });
    test('includeStringInJson does not add duplicate strings', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      await controller.includeStringInJson(testString);
      final data = await controller.readJsonAsStrings();
      expect(data.where((element) => element == testString).length, 1);
      await teardownTest(appDocDir);
    });

    test('readJsonAsStrings returns the correct data', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      final data = await controller.readJsonAsStrings();
      expect(data, isNotEmpty);
      expect(data.length, 1);
      expect(data.first, testString);
      await teardownTest(appDocDir);
    });

    test('deleteDataByName removes the correct string', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      await controller.deleteDataByName(testString);
      final data = await controller.readJsonAsStrings();
      expect(data, isEmpty);
      await teardownTest(appDocDir);
    });

    test('deleteDataByIndex removes the correct string', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      await controller.deleteDataByIndex(0);
      final data = await controller.readJsonAsStrings();
      expect(data, isEmpty);
      await teardownTest(appDocDir);
    });

    test('deleteDataByIndex does not delete on invalid indexes', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      await controller.deleteDataByIndex(1);
      final data = await controller.readJsonAsStrings();
      expect(data, isNotEmpty);
      await teardownTest(appDocDir);
    });

    test('deleteEntireJson deletes the entire file', () async {
      final (:appDocDir, :controller) = await setupTest();
      await controller.includeStringInJson(testString);
      await controller.deleteEntireJson();
      final data = await controller.readJsonAsStrings();
      expect(data, isEmpty);
      final file = File(path.join(appDocDir.path, 'favorited_names.json'));
      expect(await file.exists(), isFalse);
      await teardownTest(appDocDir);
    });

    test('readJsonAsStrings recreates file if missing and returns empty', () async {
      final (:appDocDir, :controller) = await setupTest();

      // Create the file by adding a string
      await controller.includeStringInJson(testString);
      final file = File(path.join(appDocDir.path, 'favorited_names.json'));

      // Ensure file exists initially
      expect(await file.exists(), isTrue);

      // Delete the file
      await file.delete();

      // First read after deletion - should detect error, recreate file, and return empty
      expect(await controller.readJsonAsStrings(), isEmpty);

      // Verify the file was recreated
      expect(await file.exists(), isTrue);

      // Verify the new file is empty
      final newData = await controller.readJsonAsStrings();
      expect(newData, isEmpty);

      await teardownTest(appDocDir);
    });
  });
}