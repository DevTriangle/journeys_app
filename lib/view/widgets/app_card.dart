import 'package:flutter/material.dart';
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
