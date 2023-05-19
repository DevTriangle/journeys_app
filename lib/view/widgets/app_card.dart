import 'package:flutter/material.dart';
import 'package:journeys_app/model/app_action.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/shapes.dart';

class AppToolCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const AppToolCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 0,
            shape: const RoundedRectangleBorder(),
            color: AppColors.primaryColor,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              action.icon,
              size: 25,
              color: !selected ? Theme.of(context).primaryColor : Colors.white,
            ),
            Text(
              action.label,
              style: TextStyle(fontSize: 14, color: !selected ? Theme.of(context).primaryColor : Colors.white),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
