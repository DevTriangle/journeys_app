import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/model/journey_item.dart';
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

  String _categoryValue = "";
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
                                              Expanded(
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                                  decoration: BoxDecoration(color: Colors.white),
                                                  child: DropdownButtonHideUnderline(
                                                    child: DropdownButton<String>(
                                                      dropdownColor: Colors.white,
                                                      items: snapshot.data![index].actions.map((String item) {
                                                        return DropdownMenuItem<String>(value: item, child: Text(item));
                                                      }).toList(),
                                                      value: _categoryValue,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 16,
                                                        fontFamily: "Rubik",
                                                      ),
                                                      onChanged: (value) {
                                                        _categoryValue = value!;
                                                        setDialogState(() {});
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(bottom: 6),
                                                child: Text(
                                                  "Название предмета",
                                                  style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                                                ),
                                              ),
                                              AppTextField(
                                                  hint: "",
                                                  onChanged: (value) {
                                                    _itemName = value;
                                                  }),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      viewModel.journeys[index].items.add(JourneyItem(_categoryValue, _itemName));
                                                      await viewModel.saveJourneys();

                                                      setState(() {});

                                                      Navigator.pop(context);
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
                return SizedBox();
              }
            }),
      ),
    );
  }
}
