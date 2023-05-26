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
                            isExpanded == true ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded,
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
  final Function() onAddTap;
  final Function() onTap;
  final Function(List<JourneyItem>) onChanged;
  final bool? isExpanded;
  final EdgeInsets? margin;

  const AppJourneyCard({
    super.key,
    required this.journey,
    required this.onAddTap,
    required this.onTap,
    this.isExpanded,
    this.margin = EdgeInsets.zero,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() => AppJourneyCardState();
}

class AppJourneyCardState extends State<AppJourneyCard> {
  List<JourneyItem> _items = [
    JourneyItem("Плавание", "Плавки", 1),
    JourneyItem("Плавание", "Сланцы", 1),
    JourneyItem("Плавание", "Полотенце", 1),
    JourneyItem("Плавание", "Очки", 1),
    JourneyItem("Плавание", "Шапочка", 1),
    JourneyItem("Ужин в ресторане", "Деловой костюм", 1),
    JourneyItem("Ужин в ресторане", "Наручные часы", 1),
    JourneyItem("Бег", "Кроссовки", 1),
    JourneyItem("Бег", "Футболка", 1),
    JourneyItem("Бег", "Бутылка воды", 1),
    JourneyItem("Бег", "Музыкальный плеер", 1),
    JourneyItem("Бег", "Шорты", 1),
    JourneyItem("Велотуризм", "Спортивная обувь", 1),
    JourneyItem("Велотуризм", "Спортивная одежда", 1),
    JourneyItem("Велотуризм", "Часы", 1),
    JourneyItem("Велотуризм", "Смартфон", 1),
    JourneyItem("Велотуризм", "Карта", 1),
    JourneyItem("Велотуризм", "Компас", 1),
    JourneyItem("Велотуризм", "GPS-навигатор", 1),
    JourneyItem("Велотуризм", "Велосипед", 1),
    JourneyItem("Велотуризм", "Музыкальный плеер", 1),
    JourneyItem("Велотуризм", "Изолента", 1),
    JourneyItem("Велотуризм", "Набор для ремонта шин", 1),
    JourneyItem("Велотуризм", "Дождевик", 1),
    JourneyItem("Пешеходный туризм", "Кроссовки", 1),
    JourneyItem("Пешеходный туризм", "Сумка", 1),
    JourneyItem("Пешеходный туризм", "Рюкзак", 1),
    JourneyItem("Пешеходный туризм", "Карта", 1),
    JourneyItem("Пешеходный туризм", "Компас", 1),
    JourneyItem("Пешеходный туризм", "Смартфон", 1),
    JourneyItem("Пешеходный туризм", "Музыкальный плеер", 1),
    JourneyItem("Пешеходный туризм", "Дождевик", 1),
    JourneyItem("Уход за детьми", "Коляска", 1),
    JourneyItem("Уход за детьми", "Игрушки", 1),
    JourneyItem("Уход за детьми", "Одежда", 1),
    JourneyItem("Пляж", "Плавки", 1),
    JourneyItem("Пляж", "Сланцы", 1),
    JourneyItem("Пляж", "Полотенце", 1),
    JourneyItem("Пляж", "Солнечные очки", 1),
    JourneyItem("Пляж", "Солнцезащитный крем", 1),
    JourneyItem("Официально-деловые принадлежности", "Письменные принадлежности", 1),
    JourneyItem("Официально-деловые принадлежности", "Мобильный телефон", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Ежедневник", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Планшет", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Файл", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Блок для заметок", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Портфель", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Маркер", 1),
    JourneyItem("Повседневно-деловые принадлежности", "Папка", 1),
  ];

  List<JourneyItem> _selectedItems = [];

  @override
  void initState() {
    super.initState();

    _items = [
      JourneyItem("Плавание", "Плавки", widget.journey.daysCount ~/ 5),
      JourneyItem("Плавание", "Сланцы", 1),
      JourneyItem("Плавание", "Полотенце", 1),
      JourneyItem("Плавание", "Очки", 1),
      JourneyItem("Плавание", "Шапочка", 1),
      JourneyItem("Ужин в ресторане", "Деловой костюм", 1),
      JourneyItem("Ужин в ресторане", "Наручные часы", 1),
      JourneyItem("Бег", "Кроссовки", widget.journey.daysCount ~/ 5),
      JourneyItem("Бег", "Футболка", widget.journey.daysCount * 1),
      JourneyItem("Бег", "Бутылка воды", widget.journey.daysCount * 1),
      JourneyItem("Бег", "Музыкальный плеер", 1),
      JourneyItem("Бег", "Шорты", 1),
      JourneyItem("Велотуризм", "Спортивная обувь", 1),
      JourneyItem("Велотуризм", "Спортивная одежда", widget.journey.daysCount * 1),
      JourneyItem("Велотуризм", "Часы", 1),
      JourneyItem("Велотуризм", "Смартфон", 1),
      JourneyItem("Велотуризм", "Карта", 1),
      JourneyItem("Велотуризм", "Компас", 1),
      JourneyItem("Велотуризм", "GPS-навигатор", 1),
      JourneyItem("Велотуризм", "Велосипед", 1),
      JourneyItem("Велотуризм", "Музыкальный плеер", 1),
      JourneyItem("Велотуризм", "Изолента", 1),
      JourneyItem("Велотуризм", "Набор для ремонта шин", widget.journey.daysCount * 1),
      JourneyItem("Велотуризм", "Дождевик", 1),
      JourneyItem("Пешеходный туризм", "Кроссовки", widget.journey.daysCount ~/ 5),
      JourneyItem("Пешеходный туризм", "Сумка", 1),
      JourneyItem("Пешеходный туризм", "Рюкзак", 1),
      JourneyItem("Пешеходный туризм", "Карта", 1),
      JourneyItem("Пешеходный туризм", "Компас", 1),
      JourneyItem("Пешеходный туризм", "Смартфон", 1),
      JourneyItem("Пешеходный туризм", "Музыкальный плеер", 1),
      JourneyItem("Пешеходный туризм", "Дождевик", 1),
      JourneyItem("Уход за детьми", "Коляска", 1),
      JourneyItem("Уход за детьми", "Игрушки", 1),
      JourneyItem("Уход за детьми", "Одежда", 1),
      JourneyItem("Пляж", "Плавки", widget.journey.daysCount ~/ 5),
      JourneyItem("Пляж", "Сланцы", widget.journey.daysCount ~/ 5),
      JourneyItem("Пляж", "Полотенце", widget.journey.daysCount ~/ 5),
      JourneyItem("Пляж", "Солнечные очки", 1),
      JourneyItem("Пляж", "Солнцезащитный крем", widget.journey.daysCount * 1),
      JourneyItem("Официально-деловые принадлежности", "Письменные принадлежности", widget.journey.daysCount ~/ 5),
      JourneyItem("Официально-деловые принадлежности", "Мобильный телефон", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Ежедневник", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Планшет", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Файл", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Блок для заметок", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Портфель", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Маркер", 1),
      JourneyItem("Повседневно-деловые принадлежности", "Папка", 1),
    ];

    _selectedItems.addAll(widget.journey.items);

    for (var i in widget.journey.items) {
      if (!_items.any((element) => element.name == i.name && element.category == i.category)) {
        _items.add(i);
      }
    }
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
                        Row(
                          children: [
                            IconButton(
                              onPressed: widget.onAddTap,
                              icon: Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            widget.isExpanded != null
                                ? Icon(
                                    widget.isExpanded == true ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                                    color: Colors.white,
                                  )
                                : SizedBox(),
                          ],
                        )
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
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: widget.journey.actions.length,
                        itemBuilder: (b, index) {
                          return AppCompactToolCard(
                            items: _items.where((element) => element.category == widget.journey.actions[index]).toList(),
                            margin: EdgeInsets.only(bottom: 4),
                            onItemAdd: (j, index) {
                              if (index != null) {
                                _selectedItems.insert(index, j);
                              } else {
                                _selectedItems.add(j);
                              }
                              widget.onChanged(_selectedItems);
                            },
                            onItemRemove: (j) {
                              int i = _selectedItems.indexWhere((element) => element.category == j.category && element.name == j.name);

                              if (i > -1) {
                                _selectedItems.removeAt(i);
                                widget.onChanged(_selectedItems);
                              }
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
  final Function(JourneyItem, int?) onItemAdd;
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: widget.selectedItems
                                        .any((element) => element.category == widget.items[index].category && element.name == widget.items[index].name),
                                    onChanged: (value) {
                                      if (value == true) {
                                        widget.onItemAdd(widget.items[index], null);
                                      } else {
                                        widget.onItemRemove(widget.items[index]);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                  Text(widget.items[index].name),
                                ],
                              ),
                              widget.selectedItems
                                      .any((element) => element.category == widget.items[index].category && element.name == widget.items[index].name)
                                  ? Builder(
                                      builder: (context) {
                                        int i = widget.selectedItems.indexWhere(
                                            (element) => element.category == widget.items[index].category && element.name == widget.items[index].name);
                                        return CountButtons(
                                          count: widget.selectedItems[i].count,
                                          onAddTap: () {
                                            int count = widget.selectedItems[i].count;
                                            widget.onItemRemove(widget.items[index]);
                                            widget.onItemAdd(JourneyItem(widget.items[index].category, widget.items[index].name, count + 1), i);

                                            setState(() {});
                                          },
                                          onMinusTap: () {
                                            int count = widget.selectedItems[i].count;
                                            if (count > 0) {
                                              widget.onItemRemove(widget.items[index]);
                                              widget.onItemAdd(JourneyItem(widget.items[index].category, widget.items[index].name, count - 1), i);
                                            }

                                            setState(() {});
                                          },
                                          enabled: widget.selectedItems
                                              .any((element) => element.category == widget.items[index].category && element.name == widget.items[index].name),
                                        );
                                      },
                                    )
                                  : SizedBox()
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

class CountButtons extends StatelessWidget {
  final int count;
  final Function() onAddTap;
  final Function() onMinusTap;
  final bool enabled;

  const CountButtons({super.key, required this.count, required this.onAddTap, required this.onMinusTap, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(onPressed: enabled ? onMinusTap : null, icon: Icon(Icons.remove_rounded)),
          const SizedBox(width: 2),
          Text(count.toString()),
          const SizedBox(width: 2),
          IconButton(onPressed: enabled ? onAddTap : null, icon: Icon(Icons.add_rounded)),
        ],
      ),
    );
  }
}
