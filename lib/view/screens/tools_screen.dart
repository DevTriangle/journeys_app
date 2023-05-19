import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/model/weather_item.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/view/widgets/app_text_field.dart';
import 'package:journeys_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToolsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ToolsScreenState();
}

class ToolsScreenState extends State<ToolsScreen> {
  late HomeViewModel viewModel;

  bool _weatherExpaned = true;

  String _weatherLocation = "";

  late Future<List<WeatherItem>> _weatherFuture;

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _weatherFuture = viewModel.getWeatherList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(75),
          child: Card(
            elevation: 0,
            color: AppColors.primaryColor,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    "Инструменты",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          showDialog(
            context: context,
            builder: (builder) {
              return Dialog(
                backgroundColor: AppColors.backgroundColor,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        AppTextField(
                            hint: "Название города",
                            onChanged: (value) {
                              _weatherLocation = value;
                            }),
                        TextButton(
                          onPressed: () async {
                            SharedPreferences shared =
                                await SharedPreferences.getInstance();

                            List<String> wList = [];

                            if (shared.getString("weatherList") != null) {
                              wList.addAll(List<String>.from(jsonDecode(
                                  shared.getString("weatherList")!)));
                            }

                            if (!wList.contains(_weatherLocation)) {
                              wList.add(_weatherLocation);
                            }

                            shared.setString("weatherList", jsonEncode(wList));

                            _weatherFuture = viewModel.getWeatherList();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            child: Text("Добавить"),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            AppToolCard(
              label: "Конвертер валют",
              icon: Icons.currency_exchange_rounded,
              onTap: () {},
            ),
            const SizedBox(
              height: 16,
            ),
            AppToolCard(
              label: "Погода",
              icon: Icons.cloud_rounded,
              isExpanded: _weatherExpaned,
              onTap: () {
                setState(() {
                  _weatherExpaned = !_weatherExpaned;
                });
              },
            ),
            SizedBox(height: 1),
            _weatherExpaned
                ? FutureBuilder(
                    future: _weatherFuture,
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: viewModel.weatherList.length,
                          itemBuilder: (itemBuilder, index) {
                            return AppWeatherCard(
                              item: viewModel.weatherList[index],
                            );
                          },
                        ),
                      );
                    })
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
