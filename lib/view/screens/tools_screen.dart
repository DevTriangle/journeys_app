import 'package:flutter/material.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/widgets/app_card.dart';

class ToolsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ToolsScreenState();
}

class ToolsScreenState extends State<ToolsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Card(
            elevation: 0,
            color: AppColors.primaryColor,
            margin: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "Инструменты",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            AppToolCard(
              label: "Конвертер валют",
              icon: Icons.currency_exchange_rounded,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
