import 'package:flutter/material.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/screens/create_journey_screen.dart';
import 'package:journeys_app/view/screens/home_screen.dart';
import 'package:journeys_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => HomeViewModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkFirstEnter() async {
    SharedPreferences shared = await SharedPreferences.getInstance();

    bool? firstEnter = shared.getBool("isFirstEnter");

    if (firstEnter != false) {
      shared.setBool("isFirstEnter", false);
    }

    if (firstEnter == null) {
      firstEnter = true;
    }

    return firstEnter;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Journeys App',
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.backgroundColor,
      ),
      home: FutureBuilder(
          future: checkFirstEnter(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return CreateJourneyScreen();
              } else {
                return HomeScreen();
              }
            } else {
              return SizedBox();
            }
          }),
    );
  }
}
