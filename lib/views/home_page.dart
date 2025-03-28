import 'package:flutter/material.dart';
import 'favourites_page.dart';
import 'name_generator_page.dart';
import 'settings_page.dart';


class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    page = switch (selectedIndex) {
      0 => NameGeneratorPage(),
      1 => FavouritesPage(),
      2 => SettingsPage(),
      _ => throw UnimplementedError('no widget for $selectedIndex'),
    };
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
            SafeArea(
                child: NavigationBar(
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.favorite),
                      label: 'Favorites',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.settings),
                      label: 'Settings',
                    ),

                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                )
            ),
          ],
        ),
      );
    });
  }
}