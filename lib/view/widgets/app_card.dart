import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:journeys_app/model/journey.dart';
import 'package:journeys_app/model/journey_item.dart';
import 'package:journeys_app/model/weather_item.dart';
import 'package:journeys_app/model/app_action.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/shapes.dart';

class AppToolCard extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Function() onTap;
  final bool? isExpanded;
  final EdgeInsets? margin;

  const AppToolCard({
    super.key,
    required this.label,
    this.icon,
    required this.onTap,
    this.isExpanded,
    this.margin = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: margin,
            elevation: 0,
            shape: Border(),
            color: AppColors.primaryColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    isExpanded != null
                        ? Icon(
                            isExpanded == true ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                            color: Colors.white,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppWeatherCard extends StatelessWidget {
  final WeatherItem item;
  final Function()? onTap;

  const AppWeatherCard({
    super.key,
    required this.item,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: Border(top: BorderSide(color: Colors.white, width: 0.5)),
            color: AppColors.primaryColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "${item.temp.toString()} °C",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TypeCard extends StatelessWidget {
  final String type;
  final IconData icon;
  final bool selected;
  final Function() onTap;

  const TypeCard({
    super.key,
    required this.type,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 0,
      margin: EdgeInsets.zero,
      color: selected ? Theme.of(context).primaryColor : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(),
              Icon(
                icon,
                color: selected ? Colors.white : Theme.of(context).primaryColor,
                size: 70,
              ),
              Text(
                type,
                style: TextStyle(fontSize: 18, color: selected ? Colors.white : Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final AppAction action;
  final bool selected;
  final Function(AppAction) onSelect;

  const ActionCard({
    super.key,
    required this.action,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.all(4),
      color: selected ? Theme.of(context).primaryColor : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: AppShapes.smallBorderRadius),
      child: InkWell(
        onTap: () {
          onSelect(action);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                size: 50,
                color: !selected ? Theme.of(context).primaryColor : Colors.white,
              ),
              const SizedBox(height: 10),
              Text(
                action.label,
                style: TextStyle(fontSize: 15, color: !selected ? Theme.of(context).primaryColor : Colors.white),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppJourneyCard extends StatefulWidget {
  final Journey journey;
  final Function() onTap;
  final Function(List<JourneyItem>) onChanged;
  final bool? isExpanded;
  final EdgeInsets? margin;

  const AppJourneyCard({
    super.key,
    required this.journey,
    required this.onTap,
    this.isExpanded,
    this.margin = EdgeInsets.zero,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => AppJourneyCardState();
}

class AppJourneyCardState extends State<AppJourneyCard> {
  final List<JourneyItem> _items = [
    JourneyItem("Плавание", "Плавки"),
    JourneyItem("Плавание", "Сланцы"),
    JourneyItem("Ужин в ресторане", "Деловаой костюм"),
    JourneyItem("Бег", "Кроссовки"),
    JourneyItem("Бег", "Футболка"),
    JourneyItem("Бег", "Шорты"),
    JourneyItem("Велотуризм", "Велосипед"),
    JourneyItem("Пешеходный туризм", "Кроссовки"),
    JourneyItem("Уход за детьми", "Коляска"),
    JourneyItem("Уход за детьми", "Игрушки"),
    JourneyItem("Пляж", "Плавки"),
    JourneyItem("Пляж", "Сланцы"),
    JourneyItem("Пляж", "Полотенце"),
    JourneyItem("Пляж", "Солнечные очки"),
  ];

  List<JourneyItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();

    _selectedItems.addAll(widget.journey.items);
  }

  String _getRange() {
    DateFormat date = DateFormat("dd.MM");

    return "${date.format(DateTime.parse(widget.journey.dateTime))} - ${date.format(DateTime.parse(widget.journey.dateTime).add(Duration(days: widget.journey.daysCount)))}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                margin: widget.margin,
                elevation: 0,
                shape: Border(),
                color: AppColors.primaryColor,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: widget.onTap,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        widget.isExpanded != null
                            ? Icon(
                                widget.isExpanded == true ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        widget.isExpanded == true
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: widget.journey.actions.length,
                        itemBuilder: (b, index) {
                          return AppCompactToolCard(
                            items: _items.where((element) => element.category == widget.journey.actions[index]).toList(),
                            onItemAdd: (j) {
                              _selectedItems.add(j);
                              widget.onChanged(_selectedItems);
                            },
                            onItemRemove: (j) {
                              _selectedItems.remove(j);
                              widget.onChanged(_selectedItems);
                            },
                            category: widget.journey.actions[index],
                            selectedItems: _selectedItems,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class AppCompactToolCard extends StatefulWidget {
  final String category;
  final Function(JourneyItem) onItemAdd;
  final Function(JourneyItem) onItemRemove;
  final List<JourneyItem> items;
  final List<JourneyItem> selectedItems;
  final EdgeInsets? margin;

  const AppCompactToolCard({
    super.key,
    this.margin = EdgeInsets.zero,
    required this.category,
    required this.items,
    required this.onItemAdd,
    required this.onItemRemove,
    required this.selectedItems,
  });

  @override
  State<StatefulWidget> createState() => AppCompactToolCardState();
}

class AppCompactToolCardState extends State<AppCompactToolCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Card(
                margin: widget.margin,
                elevation: 0,
                shape: Border(),
                color: AppColors.primaryColor,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    isExpanded = !isExpanded;
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.category,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        isExpanded != null
                            ? Icon(
                                isExpanded == true ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                color: Colors.white,
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        isExpanded == true
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.items.length,
                        itemBuilder: (b, index) {
                          return Row(
                            children: [
                              Checkbox(
                                value: widget.selectedItems
                                    .any((element) => element.category == widget.items[index].category && element.name == widget.items[index].name),
                                onChanged: (value) {
                                  if (value == true) {
                                    widget.onItemAdd(widget.items[index]);
                                  } else {
                                    widget.onItemRemove(widget.items[index]);
                                  }
                                  setState(() {});
                                },
                              ),
                              Text(widget.items[index].name),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
