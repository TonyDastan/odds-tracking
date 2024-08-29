import 'package:flutter/material.dart';
import 'package:odds_tracker/Dashboard.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odds Record',
 theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BetDashboardApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}