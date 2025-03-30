import 'package:flutter/material.dart';

class GameCard extends StatelessWidget {
  final String gameName;
  final String? iconPath;
  final bool showText;

  const GameCard({
    super.key,
    required this.gameName,
    this.iconPath,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/$gameName');
      },
      child: Card(
        color: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null)
                Center(child: Image.asset(iconPath!, width: 80, height: 80)),
              if (showText)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    gameName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
