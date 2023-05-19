import 'package:flutter/material.dart';
import 'package:journeys_app/view/screens/create_journey_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journeys App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CreateJourneyScreen(),
    );
  }
}
