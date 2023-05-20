import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/journey.dart';

class JourneyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JourneyScreenState();
}

class JourneyScreenState extends State<JourneyScreen> {
  late HomeViewModel viewModel;
  late Future<List<Journey>> _getJourneys;
  Journey? currentJourney;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    _getJourneys = viewModel.loadJourneys();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
            future: _getJourneys,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: ((context, index) {
                          return AppJourneyCard(
                            journey: snapshot.data![index],
                            onChanged: (list) {
                              viewModel.journeys[index].items = list;
                              viewModel.saveJourneys();
                              setState(() {});
                            },
                            onTap: () {
                              if (currentJourney == snapshot.data![index]) {
                                currentJourney = null;
                              } else {
                                currentJourney = snapshot.data![index];
                              }

                              setState(() {});
                            },
                            isExpanded: currentJourney == snapshot.data![index],
                          );
                        }),
                      ),
                    )
                  ],
                );
              } else {
                return SizedBox();
              }
            }),
      ),
    );
  }
}
