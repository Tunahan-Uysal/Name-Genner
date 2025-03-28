import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_state.dart';
import 'big_card.dart';

class NameGeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var wordPair = appState.current;
    IconData icon;
    if (appState.favorites.contains(wordPair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(wordPair: wordPair),
            SizedBox(height: 12),

            Row(mainAxisSize: MainAxisSize.min,
              children: [

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appState.favorites.contains(wordPair)
                        ? Colors.red
                        : null,
                    foregroundColor: appState.favorites.contains(wordPair)
                        ? Colors.white
                        : null,
                  ),
                  onPressed: () {
                    appState.toggleFavourite();
                  },
                  icon: Icon(icon),
                  label: Text('Favourite'),
                ),

                SizedBox(width: 6),
                ElevatedButton(
                  onPressed: () {
                    appState.getNextWord();
                  },
                  child: Text('Next'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}