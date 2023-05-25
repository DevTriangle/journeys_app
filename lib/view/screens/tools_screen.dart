import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/model/currency_item.dart';
import 'package:journeys_app/model/weather_item.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/view/widgets/app_text_field.dart';
import 'package:journeys_app/viewmodel/home_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../shapes.dart';
import '../widgets/app_snackbar.dart';

class ToolsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ToolsScreenState();
}

class ToolsScreenState extends State<ToolsScreen> {
  late HomeViewModel viewModel;

  bool _weatherExpaned = true;
  bool _currencyEnabled = false;

  String _weatherLocation = "";
  String _currencyValue = "USD";

  CurrencyItem _selectedCurrency = CurrencyItem("USD", 0.0);

  String _firstCurrencyText = "";

  late Future<List<WeatherItem>> _weatherFuture;

  final TextEditingController _tController = TextEditingController();
  final TextEditingController _currencyController = TextEditingController();

  @override
  void initState() {
    super.initState();

    viewModel = Provider.of<HomeViewModel>(context, listen: false);

    _weatherFuture = viewModel.getWeatherList();

    _tController.text = "RUB";
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (builder) {
                return Dialog(
                  backgroundColor: AppColors.backgroundColor,
                  child: Wrap(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              "Название города",
                              style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                            ),
                          ),
                          AppTextField(
                              hint: "",
                              onChanged: (value) {
                                _weatherLocation = value;
                              }),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (_weatherLocation.trim().isNotEmpty) {
                                    SharedPreferences shared = await SharedPreferences.getInstance();

                                    List<String> wList = [];

                                    if (shared.getString("weatherList") != null) {
                                      wList.addAll(List<String>.from(jsonDecode(shared.getString("weatherList")!)));
                                    }

                                    if (!wList.contains(_weatherLocation)) {
                                      wList.add(_weatherLocation);
                                    }

                                    await shared.setString("weatherList", jsonEncode(wList));

                                    _weatherFuture = viewModel.getWeatherList();

                                    setState(() {});

                                    Navigator.pop(context);
                                  }
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
                  ),
                );
              },
            );
          },
          child: Icon(
            Icons.add_rounded,
            color: Colors.white,
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            AppToolCard(
              label: "Конвертер валют",
              icon: Icons.currency_exchange_rounded,
              onTap: () {
                if (_currencyEnabled) {
                  showDialog(
                    context: context,
                    builder: (builder) {
                      return StatefulBuilder(builder: (context, setDialogState) {
                        return Dialog(
                          backgroundColor: AppColors.backgroundColor,
                          child: Wrap(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Expanded(child: Text("Валюта")),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(child: Text("Количество")),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          hint: "",
                                          controller: _tController,
                                          onChanged: (value) {},
                                          readOnly: true,
                                          inputType: TextInputType.number,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: AppTextField(
                                            hint: "",
                                            onChanged: (value) {
                                              setState(() {
                                                _firstCurrencyText = value;

                                                if (_firstCurrencyText.isNotEmpty) {
                                                  _currencyController.text = (double.parse(_firstCurrencyText) * _selectedCurrency.rate).toStringAsFixed(2);
                                                }
                                              });

                                              setDialogState(() {});
                                            }),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                          decoration: BoxDecoration(color: Colors.white),
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              dropdownColor: Colors.white,
                                              items: viewModel.currencyList.map((CurrencyItem item) {
                                                return DropdownMenuItem<String>(value: item.currency, child: Text(item.currency));
                                              }).toList(),
                                              value: _currencyValue,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                fontFamily: "Rubik",
                                              ),
                                              onChanged: (value) {
                                                _currencyValue = value!;

                                                for (var c in viewModel.currencyList) {
                                                  if (c.currency == value) {
                                                    _selectedCurrency = c;

                                                    if (_firstCurrencyText.isNotEmpty) {
                                                      _currencyController.text = (double.parse(_firstCurrencyText) * _selectedCurrency.rate).toStringAsFixed(2);
                                                    }
                                                  }
                                                }

                                                setDialogState(() {});
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: AppTextField(
                                          hint: "",
                                          onChanged: (value) {},
                                          controller: _currencyController,
                                          readOnly: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          child: Text("Закрыть"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                  );
                } else {
                  final snackBar = SnackBar(
                      shape: AppShapes.roundedRectangleShape,
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      behavior: SnackBarBehavior.floating,
                      content: const AppSnackBarContent(
                        label: "Конвертер загружается...",
                        icon: Icons.sync_rounded,
                      ));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
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
                      if (snapshot.hasData) {
                        for (var c in viewModel.currencyList) {
                          if (c.currency == _currencyValue) {
                            _selectedCurrency = c;
                          }
                        }

                        _currencyEnabled = true;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: viewModel.weatherList.length,
                            itemBuilder: (itemBuilder, index) {
                              return AppWeatherCard(
                                item: viewModel.weatherList[index],
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (builder) {
                                      return Dialog(
                                        backgroundColor: AppColors.backgroundColor,
                                        child: Wrap(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Text(
                                                      "Удалить выбранный город из списка?",
                                                      style: TextStyle(color: AppColors.hintColor, fontSize: 14),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 16,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                          child: Text("Отменить"),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          SharedPreferences shared = await SharedPreferences.getInstance();

                                                          List<String> wList = [];

                                                          if (shared.getString("weatherList") != null) {
                                                            wList.addAll(List<String>.from(jsonDecode(shared.getString("weatherList")!)));
                                                          }

                                                          wList.remove(viewModel.weatherList[index].name);

                                                          await shared.setString("weatherList", jsonEncode(wList));

                                                          _weatherFuture = viewModel.getWeatherList();

                                                          setState(() {});

                                                          Navigator.pop(context);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                          child: Text("Удалить"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    })
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
