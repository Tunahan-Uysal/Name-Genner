import 'dart:developer';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>[];

  void getNextWord() {
    current = WordPair.random();
    notifyListeners();
  }

  void toggleFavourite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
      log('Removed Favourite $current');
    } else {
      favorites.add(current);
      log('Added Favourite $current');
    }
    notifyListeners();
  }
}