import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journeys_app/model/journey.dart';
import 'package:journeys_app/view/screens/home_screen.dart';
import 'package:journeys_app/view/shapes.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/view/widgets/app_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/app_action.dart';
import '../colors.dart';
import '../widgets/app_snackbar.dart';

class ActionsScreen extends StatefulWidget {
  final Journey journey;
  final Function(List<AppAction>)? onChanged;
  final bool isEditing;
  const ActionsScreen({super.key, required this.journey, required this.isEditing, this.onChanged});

  @override
  State<StatefulWidget> createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  late Future<List<AppAction>> _loadActions;
  String _actionName = "";

  final List<AppAction> _actions = [
    AppAction("Плавание", Icons.pool_rounded),
    AppAction("Повседневно-деловые принадлежности", Icons.cases_rounded),
    AppAction("Официально-деловые принадлежности", Icons.business_center_rounded),
    AppAction("Ужин в ресторане", Icons.dinner_dining_rounded),
    AppAction("Бег", Icons.run_circle_outlined),
    AppAction("Велотуризм", Icons.pedal_bike_rounded),
    AppAction("Пешеходный туризм", Icons.landscape_rounded),
    AppAction("Уход за детьми", Icons.child_friendly_rounded),
    AppAction("Пляж", Icons.wb_sunny_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _loadActions = _getActions();

    for (var a in widget.journey.actions) {
      _selectedActions.add(AppAction(a, _actions.firstWhere((element) => element.label == a).icon));
    }
  }

  final List<AppAction> _userActions = [];
  final List<Journey> _journeys = [];

  List<AppAction> _selectedActions = [];

  Future<List<AppAction>> _getActions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _userActions.clear();
    if (sharedPreferences.getString("userActions") != null) {
      List<String> ac = List.from(jsonDecode(sharedPreferences.getString("userActions").toString()));

      for (var a in ac) {
        _userActions.add(AppAction(a, Icons.settings_rounded));
      }
    }

    return _userActions;
  }

  Future<void> _createAction() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _userActions.add(AppAction(_actionName, Icons.settings_rounded));

    List<String> ac = [];
    for (var a in _userActions) {
      ac.add(a.label);
    }

    await sharedPreferences.setString("userActions", jsonEncode(ac));
    _loadActions = _getActions();
    Navigator.pop(context);
    setState(() {});
  }

  Future<List<Journey>> _loadJourneys() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    _journeys.clear();
    if (sharedPreferences.getString("journeys") != null) {
      Iterable l = json.decode(sharedPreferences.getString("journeys").toString());
      List<Journey> journeys = List.from(l.map((e) => Journey.fromJson(e)));

      _journeys.addAll(journeys);
    }

    return _journeys;
  }

  Future<void> _createJourney() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> actions = [];
    for (var a in _selectedActions) {
      actions.add(a.label);
    }
    await _loadJourneys();
    _journeys.add(Journey(widget.journey.destination, widget.journey.dateTime, widget.journey.daysCount, actions, widget.journey.items));
    await sharedPreferences.setString("journeys", jsonEncode(_journeys.map((e) => e.toJson()).toList()));
    Navigator.push(context, MaterialPageRoute(builder: (b) => HomeScreen()));
  }

  void createActionDialog() {
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
                    const Text(
                      "Создание действия",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "Название",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.hintColor,
                      ),
                    ),
                    AppTextField(
                      hint: "",
                      onChanged: (value) {
                        _actionName = value;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 0,
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                            color: AppColors.secondaryColor,
                            child: InkWell(
                              onTap: () {
                                if (_actionName.trim().isNotEmpty) {
                                  _createAction();
                                } else {}
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Создать",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
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
  }

  String _getRange() {
    DateFormat date = DateFormat("dd.MM");

    return "${date.format(DateTime.parse(widget.journey.dateTime))} - ${date.format(DateTime.parse(widget.journey.dateTime).add(Duration(days: widget.journey.daysCount)))}";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(widget.isEditing ? 102 : 50),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      widget.isEditing ? "Изменить поездку" : "Действия",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
                widget.isEditing
                    ? Container(
                        color: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.journey.destination,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    _getRange(),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GridView.builder(
                  itemCount: _actions.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1.7),
                  itemBuilder: (context, index) {
                    return ActionCard(
                      action: _actions[index],
                      selected: _selectedActions.any((element) => element.label == _actions[index].label),
                      onSelect: (action) {
                        if (_selectedActions.any((element) => element.label == _actions[index].label)) {
                          _selectedActions.removeAt(_selectedActions.indexWhere((element) => element.label == _actions[index].label));
                        } else {
                          _selectedActions.add(action);
                        }

                        setState(() {});
                      },
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Пользовательское",
                        style: TextStyle(fontSize: 16, color: AppColors.hintColor),
                      ),
                    ],
                  ),
                ),
                FutureBuilder(
                  future: _loadActions,
                  builder: (b, snapshot) {
                    if (snapshot.hasData && _userActions.isNotEmpty) {
                      return GridView.builder(
                        itemCount: _userActions.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1.7),
                        itemBuilder: (context, index) {
                          return ActionCard(
                            action: _userActions[index],
                            selected: _selectedActions.contains(_userActions[index]),
                            onSelect: (action) {
                              if (_selectedActions.contains(action)) {
                                _selectedActions.remove(action);
                              } else {
                                _selectedActions.add(action);
                              }

                              setState(() {});
                            },
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 1,
                        margin: EdgeInsets.zero,
                        shape: AppShapes.smallRoundedRectangleShape,
                        color: Theme.of(context).primaryColor,
                        child: InkWell(
                          onTap: () {
                            createActionDialog();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Добавить действия",
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: 51,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 0,
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                      color: AppColors.secondaryColor,
                      child: InkWell(
                        onTap: widget.isEditing
                            ? () {
                                widget.onChanged!(_selectedActions);
                                Navigator.push(context, MaterialPageRoute(builder: (builder) => HomeScreen()));
                              }
                            : () {
                                if (_selectedActions.isNotEmpty) {
                                  _createJourney();
                                } else {
                                  final snackBar = SnackBar(
                                      shape: AppShapes.roundedRectangleShape,
                                      margin: const EdgeInsets.all(10),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                      behavior: SnackBarBehavior.floating,
                                      content: const AppSnackBarContent(
                                        label: "Выберите действия",
                                        icon: Icons.select_all_rounded,
                                      ));

                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              },
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.isEditing ? "Сохранить" : "Собрать багаж",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
