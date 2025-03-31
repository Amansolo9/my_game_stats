import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/home_screen.dart';
import 'view_models/home_view_model.dart';
import 'views/clash_of_clans_screen.dart';
import 'views/brawl_stars_screen.dart';
import 'view_models/brawl_stars_view_model.dart';
import 'view_models/clash_of_clans_view_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => BrawlStarsViewModel()),
        ChangeNotifierProvider(create: (_) => ClashOfClansViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Stats',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/Clash of Clans': (context) => const ClashOfClansScreen(),
        '/Brawl Stars': (context) => const BrawlStarsScreen(),
      },
    );
  }
}
