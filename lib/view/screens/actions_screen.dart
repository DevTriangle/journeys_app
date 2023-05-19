import 'package:flutter/material.dart';
import 'package:journeys_app/view/widgets/app_card.dart';

import '../../model/app_action.dart';
import '../colors.dart';

class ActionsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActionsScreenState();
}

class ActionsScreenState extends State<ActionsScreen> {
  final List<AppAction> actions = [
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
  List<AppAction> _selectedActions = [];

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
        body: GridView.builder(
          itemCount: actions.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1 / 1.7),
          itemBuilder: (context, index) {
            return ActionCard(
              action: actions[index],
              selected: _selectedActions.contains(actions[index]),
              onSelect: (action) {
                if (_selectedActions.contains(action)) {
                  _selectedActions.remove(action);
                } else {
                  _selectedActions.add(action);
                }
              },
            );
          },
        ),
        bottomNavigationBar: Container(
          height: 100,
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
                                "Начать сбор",
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
