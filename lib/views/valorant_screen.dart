import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/valorant_view_model.dart';

class ValorantScreen extends StatelessWidget {
  const ValorantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ValorantViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Valorant Stats')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                viewModel.initiateRSOLogin();
              },
              child: const Text('Login with Riot'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                viewModel.fetchUserStats();
              },
              child: const Text('Fetch User Stats'),
            ),
            const SizedBox(height: 16),
            if (viewModel.userStats != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User Stats:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text('Sub: ${viewModel.userStats!['sub']}'),
                    Text('CPID: ${viewModel.userStats!['cpid']}'),
                  ],
                ),
              )
            else if (viewModel.isLoading)
              const CircularProgressIndicator()
            else if (viewModel.errorMessage.isNotEmpty)
              Text(
                'Error: ${viewModel.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
