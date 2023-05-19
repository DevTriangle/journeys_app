import 'package:flutter/material.dart';

import '../shapes.dart';

class AppDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final void Function(String item)? onChanged;

  const AppDropdown(
      {super.key,
      this.label = "",
      required this.value,
      required this.items,
      this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      this.margin = const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor.withOpacity(0.9)),
          ),
        ),
        const SizedBox(height: 4),
        Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.zero),
            width: double.infinity,
            padding: padding,
            margin: margin,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                  borderRadius: AppShapes.borderRadius,
                  dropdownColor: Colors.white,
                  items: items.map((String item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                  value: value,
                  style: TextStyle(color: Theme.of(context).hintColor, fontWeight: FontWeight.w500),
                  onChanged: onChanged != null ? (item) => onChanged!(item.toString()) : null),
            ))
      ],
    );
  }
}
