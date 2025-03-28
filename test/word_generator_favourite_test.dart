import 'package:flutter_test/flutter_test.dart';
import 'package:name_genner/models/app_state.dart';

void main() {
  group('MyAppState', () {
    late MyAppState appState;

    setUp(() {
      appState = MyAppState();
    });

    test('getNextWord() updates the current word pair', () {
      final initialWordPair = appState.current;
      appState.getNextWord();
      expect(appState.current, isNot(equals(initialWordPair)));
    });

    test('toggleFavourite() adds a word to favorites if not present', () {
      final initialFavoritesCount = appState.favorites.length;
      final currentWord = appState.current;
      appState.toggleFavourite();
      expect(appState.favorites.length, equals(initialFavoritesCount + 1));
      expect(appState.favorites.contains(currentWord), isTrue);
    });

    test('toggleFavourite() removes a word from favorites if present', () {
      appState.toggleFavourite(); // Add it once
      final initialFavoritesCount = appState.favorites.length;
      final currentWord = appState.current;
      appState.toggleFavourite(); // Remove it
      expect(appState.favorites.length, equals(initialFavoritesCount - 1));
      expect(appState.favorites.contains(currentWord), isFalse);
    });
  });
}