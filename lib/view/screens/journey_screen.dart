import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/view/screens/actions_screen.dart';
import 'package:journeys_app/view/screens/create_journey_screen.dart';
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PopupMenuButton<int>(
                onSelected: (item) {
                  switch (item) {
                    case 0:
                      {
                        viewModel.journeys.remove(currentJourney);
                        viewModel.saveJourneys();
                        currentJourney = null;
                        setState(() {});
                      }
                      break;
                    case 1:
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (builder) => ActionsScreen(
                              journey: currentJourney!,
                              isEditing: true,
                              onChanged: (list) {
                                List<String> actions = [];
                                for (var a in list) {
                                  actions.add(a.label);
                                }

                                viewModel.journeys[viewModel.journeys.indexOf(currentJourney!)].actions = actions;
                                viewModel.saveJourneys();
                              },
                            ),
                          ),
                        );
                      }
                      break;
                    case 2:
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (builder) => CreateJourneyScreen()));
                      }
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text('Удалить выбранную поездку'),
                    enabled: currentJourney != null,
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text('Изменить выбранную поездку'),
                    enabled: currentJourney != null,
                  ),
                  PopupMenuItem<int>(value: 2, child: Text('Добавить поездку')),
                ],
              ),
            ],
          ),
        ),
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
