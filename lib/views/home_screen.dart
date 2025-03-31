import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/game_card.dart';
import 'time_statistics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.example.my_game_stats/usage');
  List<Map<String, dynamic>> _appUsageData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchAppUsageData();
  }

  Future<void> _fetchAppUsageData() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getAppUsage');
      setState(() {
        _appUsageData =
            result.map((e) => Map<String, dynamic>.from(e)).toList();
      });
    } catch (e) {
      print('Failed to fetch app usage data: $e');
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TimeStatisticsScreen(),
                ),
              );
            },
          ),
        ],
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
