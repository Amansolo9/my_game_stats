import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';

class TimeStatisticsScreen extends StatefulWidget {
  const TimeStatisticsScreen({super.key});

  @override
  State<TimeStatisticsScreen> createState() => _TimeStatisticsScreenState();
}

class _TimeStatisticsScreenState extends State<TimeStatisticsScreen> {
  static const platform = MethodChannel('com.example.my_game_stats/usage');
  List<Map<String, dynamic>> _appUsageData = [];

  @override
  void initState() {
    super.initState();
    _checkAndRequestPermission();
  }

  Future<void> _checkAndRequestPermission() async {
    if (Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.example.my_game_stats/usage');
        final bool hasPermission = await platform.invokeMethod(
          'checkUsagePermission',
        );
        if (!hasPermission) {
          final intent = AndroidIntent(
            action: 'android.settings.USAGE_ACCESS_SETTINGS',
          );
          await intent.launch();
        } else {
          _fetchAppUsageData();
        }
      } catch (e) {
        print('Error checking usage access permission: $e');
      }
    }
  }

  Future<void> _fetchAppUsageData() async {
    try {
      print('Attempting to fetch app usage data...');
      final List<dynamic> result = await platform.invokeMethod('getAppUsage');
      print('Raw data received: $result');
      setState(() {
        _appUsageData =
            result.map((e) {
              final Map<String, dynamic> appData = Map<String, dynamic>.from(e);
              appData['appIcon'] =
                  appData['appIcon'] != null
                      ? MemoryImage(
                        Uint8List.fromList(List<int>.from(appData['appIcon'])),
                      )
                      : null;
              return appData;
            }).toList();
      });
      print('Processed app usage data: $_appUsageData');
    } catch (e) {
      print('Failed to fetch app usage data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Statistics'),
        backgroundColor: Colors.brown,
      ),
      body:
          _appUsageData.isEmpty
              ? const Center(
                child: Text(
                  'No data available. Please grant usage access permission.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: _appUsageData.length,
                itemBuilder: (context, index) {
                  final app = _appUsageData[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading:
                          app['appIcon'] != null
                              ? CircleAvatar(backgroundImage: app['appIcon'])
                              : const Icon(Icons.android, color: Colors.white),
                      title: Text(
                        app['appName'] ?? app['packageName'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Time: ${(app['timeInForeground'] / 60000).toStringAsFixed(2)} min',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                  );
                },
              ),
      backgroundColor: Colors.black,
    );
  }
}
