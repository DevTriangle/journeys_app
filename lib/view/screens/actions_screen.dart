import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/view/shapes.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/app_action.dart';
import '../colors.dart';

class ActionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  late Future<List<AppAction>> _loadActions;

  final List<AppAction> _actions = [
    AppAction("Плавание", Icons.pool_rounded),
    AppAction("Повседневно-деловые Принадлежности", Icons.cases_rounded),
    AppAction("Официально-деловые Принадлежности", Icons.business_center_rounded),
    AppAction("Ужин в ресторане", Icons.dinner_dining_rounded),
    AppAction("Бег", Icons.run_circle_outlined),
    AppAction("Велотуризм", Icons.pedal_bike_rounded),
    AppAction("Пешеходный туризм", Icons.landscape_rounded),
    AppAction("Уход за детьми", Icons.child_friendly_rounded),
    AppAction("Пляж", Icons.wb_sunny_rounded),
  ];

  final List<AppAction> _userActions = [];

  List<AppAction> _selectedActions = [];

  Future<List<AppAction>> _getActions() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("userActions") != null) {
      List<String> ac = List.from(jsonDecode(sharedPreferences.getString("userActions").toString()));

      for (var a in ac) {
        _userActions.add(AppAction(a, Icons.settings_rounded));
      }
    }

    return _userActions;
  }

  @override
  void initState() {
    super.initState();

    _loadActions = _getActions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          child: Container(
            color: Theme.of(context).primaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Действия",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(50),
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
                      selected: _selectedActions.contains(_actions[index]),
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
                          onTap: () {},
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Добавить пользовательское событие",
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
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Собрать багаж",
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
