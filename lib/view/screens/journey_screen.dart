import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/view/screens/actions_screen.dart';
import 'package:journeys_app/view/screens/create_journey_screen.dart';
import 'package:journeys_app/model/journey_item.dart';
import 'package:journeys_app/view/screens/home_screen.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/journey.dart';
import '../colors.dart';
import '../widgets/app_text_field.dart';

class JourneyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JourneyScreenState();
}

class JourneyScreenState extends State<JourneyScreen> {
  late HomeViewModel viewModel;
  late Future<List<Journey>> _getJourneys;
  Journey? currentJourney;

  String _actionValue = "";
  String _itemName = "";

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
                if (snapshot.data!.isNotEmpty) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: ((context, index) {
                            return AppJourneyCard(
                              margin: EdgeInsets.only(bottom: 4),
                              journey: snapshot.data![index],
                              onChanged: (list) async {
                                viewModel.journeys[index].items = list;
                                await viewModel.saveJourneys();
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
                              onAddTap: () {
                                _actionValue = snapshot.data![index].actions[0];

                                showDialog(
                                  context: context,
                                  builder: (builder) {
                                    return Dialog(
                                      backgroundColor: AppColors.backgroundColor,
                                      child: StatefulBuilder(builder: (context, setDialogState) {
                                        return Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 6),
                                                  child: Text(
                                                    "Действие",
                                                    style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      dropdownColor: Colors.white,
                                                      items: snapshot.data![index].actions.map((String item) {
                                                        return DropdownMenuItem<String>(value: item, child: Text(item));
                                                      }).toList(),
                                                      value: _actionValue,
                                                      isExpanded: true,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                      onChanged: (value) {
                                                        _actionValue = value!;
                                                        setDialogState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(bottom: 6, top: 6),
                                                  child: Text(
                                                    "Название предмета",
                                                    style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                                                  ),
                                                ),
                                                AppTextField(
                                                  hint: "",
                                                  onChanged: (value) {
                                                    _itemName = value;
                                                  },
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (_itemName.trim().isNotEmpty) {
                                                          viewModel.journeys[index].items.add(JourneyItem(_actionValue, _itemName, 0));
                                                          await viewModel.saveJourneys();

                                                          setState(() {});

                                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => HomeScreen()));
                                                        } else {}
                                                      },
                                                      child: Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        child: Text("Добавить"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]),
                                            ),
                                          ],
                                        );
                                      }),
                                    );
                                  },
                                );
                              },
                            );
                          }),
                        ),
                      )
                    ],
                  );
                } else {
                  return Center(
                    child: Text("Путешествий нет!"),
                  );
                }
              } else {
                return Center(
                  child: Text("Путешествий нет!"),
                );
              }
            }),
      ),
    );
  }
}
