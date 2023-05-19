import 'package:flutter/material.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/widgets/app_dropdowm.dart';
import 'package:journeys_app/view/widgets/app_text_field.dart';

class CreateJourneyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CreateJourneyScreenState();
}

class CreateJourneyScreenState extends State<CreateJourneyScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthContorller = TextEditingController();

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
                  "Новая поездка",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Куда",
                style: TextStyle(color: AppColors.hintColor, fontSize: 16),
              ),
            ),
            AppTextField(
              hint: "",
              onChanged: (text) {},
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Дата поездки",
                style: TextStyle(color: AppColors.hintColor, fontSize: 16),
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: AppTextField(
                    hint: "",
                    controller: _dateController,
                    onChanged: (text) {},
                    onTap: () {},
                    readOnly: true,
                  ),
                ),
                Container(
                  color: AppColors.hintColor,
                  width: 1.5,
                  height: 0,
                ),
                Expanded(
                  flex: 10,
                  child: AppTextField(
                    hint: "",
                    onChanged: (text) {},
                    controller: _monthContorller,
                    onTap: () {},
                    icon: Icons.arrow_drop_down_circle_outlined,
                    readOnly: true,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Длительность пребывания",
                style: TextStyle(color: AppColors.hintColor, fontSize: 16),
              ),
            ),
            // Slider
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Тип поездки",
                style: TextStyle(color: AppColors.hintColor, fontSize: 16),
              ),
            ),
            InkWell(
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                color: AppColors.secondaryColor,
                child: Row(
                  children: [
                    Text("Выбрать действия"),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
