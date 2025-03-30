import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/clash_of_clans_view_model.dart';

class ClashOfClansScreen extends StatelessWidget {
  const ClashOfClansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ClashOfClansViewModel>(context);
    final tagController = TextEditingController(text: '#');

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Clash of Clans',
          style: TextStyle(fontFamily: 'ClashFont', fontSize: 24),
        ),
        backgroundColor: Colors.brown,
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tagController,
                    decoration: InputDecoration(
                      labelText: 'Player Tag',
                      hintText: 'Enter player tag (e.g., 123456)',
                      labelStyle: const TextStyle(
                        fontFamily: 'ClashFont',
                        fontSize: 18,
                        color: Colors.orange,
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: 'ClashFont',
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      viewModel.fetchPlayerData(tagController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      textStyle: const TextStyle(
                        fontFamily: 'ClashFont',
                        fontSize: 18,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Fetch Player Stats'),
                  ),
                  const SizedBox(height: 16),
                  if (viewModel.isLoading)
                    const CircularProgressIndicator(color: Colors.orange)
                  else if (viewModel.errorMessage.isNotEmpty)
                    Text(
                      'Error: ${viewModel.errorMessage}',
                      style: const TextStyle(
                        color: Colors.red,
                        fontFamily: 'ClashFont',
                        fontSize: 18,
                      ),
                    )
                  else if (viewModel.playerData != null)
                    Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${viewModel.playerData!['name']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Tag: ${viewModel.playerData!['tag']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Trophies: ${viewModel.playerData!['trophies']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Best Trophies: ${viewModel.playerData!['bestTrophies']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'War Stars: ${viewModel.playerData!['warStars']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Attack Wins: ${viewModel.playerData!['attackWins']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Defense Wins: ${viewModel.playerData!['defenseWins']}',
                              style: const TextStyle(
                                fontFamily: 'ClashFont',
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
