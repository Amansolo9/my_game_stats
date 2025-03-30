import 'package:flutter/material.dart';
import '../widgets/game_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final games = [
      {'name': 'Clash of Clans', 'icon': 'assets/clash/logo.png'},
      {'name': 'Brawl Stars', 'icon': null},
      {'name': 'Valorant', 'icon': null},
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Game Stats'),
        backgroundColor: Colors.brown,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GameCard(
              gameName: games[index]['name']!,
              iconPath: games[index]['icon'],
              showText: games[index]['name'] != 'Clash of Clans',
            ),
          );
        },
      ),
    );
  }
}
