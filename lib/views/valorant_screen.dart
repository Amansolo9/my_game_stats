import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/valorant_view_model.dart';

class ValorantScreen extends StatelessWidget {
  const ValorantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ValorantViewModel>(context);
    final gameNameController = TextEditingController();
    final tagLineController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Valorant Stats',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF4654), // Valorant red
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Details Section
              Card(
                color: const Color(0xFF0F1923), // Valorant dark blue
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Player Lookup',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: gameNameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Game Name',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Enter game name',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Color(0xFF1F2731),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: tagLineController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Tag Line',
                          labelStyle: TextStyle(color: Colors.grey),
                          hintText: 'Enter tag line (e.g., NA1)',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Color(0xFF1F2731),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            viewModel.fetchAccountDetails(
                              gameNameController.text,
                              tagLineController.text,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF4654),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Fetch Player Details'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Match History Section (Updated)
              if (viewModel.accountData != null)
                Card(
                  color: const Color(0xFF0F1923),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Match History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Using PUUID: ${viewModel.accountData!['puuid']}',
                          style: const TextStyle(color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              viewModel.fetchMatchHistory();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF4654),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: const Text('Fetch Match History'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Results Section
              if (viewModel.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: Color(0xFFFF4654)),
                )
              else if (viewModel.errorMessage.isNotEmpty)
                Card(
                  color: Colors.red[900],
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Error: ${viewModel.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                )
              else ...[
                // Account Data Results
                if (viewModel.accountData != null)
                  Card(
                    color: const Color(0xFF1F2731),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Player Details',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'PUUID: ${viewModel.accountData!['puuid']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Game Name: ${viewModel.accountData!['gameName']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Tag Line: ${viewModel.accountData!['tagLine']}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Match Data Results (Updated)
                if (viewModel.matchData != null)
                  Card(
                    color: const Color(0xFF1F2731),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Match History',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (viewModel.matchData!.containsKey('history') &&
                              (viewModel.matchData!['history'] as List)
                                  .isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount:
                                  (viewModel.matchData!['history'] as List)
                                      .length,
                              itemBuilder: (context, index) {
                                final matchList =
                                    viewModel.matchData!['history'] as List;
                                final match = matchList[index];
                                return ListTile(
                                  title: Text(
                                    'Match ID: ${match['matchId']}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    'Game Start: ${DateTime.fromMillisecondsSinceEpoch(match['gameStartTimeMillis']).toString()}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                );
                              },
                            )
                          else
                            const Text(
                              'No match history found',
                              style: TextStyle(color: Colors.white),
                            ),
                        ],
                      ),
                    ),
                  ),

                // Match Details Results
                if (viewModel.matchDetailsList.isNotEmpty)
                  ...viewModel.matchDetailsList.map((matchDetails) {
                    return Card(
                      color: const Color(0xFF1F2731),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Match Details',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Match ID: ${matchDetails['matchInfo']?['matchId'] ?? 'Unknown'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Game Mode: ${matchDetails['matchInfo']?['gameMode'] ?? 'Unknown'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Map: ${matchDetails['matchInfo']?['mapId'] ?? 'Unknown'}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
