import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/brawl_stars_view_model.dart';

class BrawlStarsScreen extends StatelessWidget {
  const BrawlStarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<BrawlStarsViewModel>(context);
    final tagController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Brawl Stars Player Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tagController,
              decoration: const InputDecoration(
                labelText: 'Player Tag',
                hintText: 'Enter player tag (e.g., #123456)',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.fetchPlayerData(tagController.text);
              },
              child: const Text('Fetch Player Stats'),
            ),
            const SizedBox(height: 16),
            if (viewModel.isLoading)
              const CircularProgressIndicator()
            else if (viewModel.errorMessage.isNotEmpty)
              Text(
                'Error: ${viewModel.errorMessage}',
                style: const TextStyle(color: Colors.red),
              )
            else if (viewModel.playerData != null)
              Expanded(
                child: ListView(
                  children: [
                    Text('Name: ${viewModel.playerData!['name']}'),
                    Text('Tag: ${viewModel.playerData!['tag']}'),
                    Text('Trophies: ${viewModel.playerData!['trophies']}'),
                    Text(
                      'Highest Trophies: ${viewModel.playerData!['highestTrophies']}',
                    ),
                    Text(
                      '3v3 Victories: ${viewModel.playerData!['3vs3Victories']}',
                    ),
                    Text(
                      'Solo Victories: ${viewModel.playerData!['soloVictories']}',
                    ),
                    Text(
                      'Duo Victories: ${viewModel.playerData!['duoVictories']}',
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
