import 'package:flutter/material.dart';
import 'package:journeys_app/model/journey.dart';
import 'package:journeys_app/view/colors.dart';
import 'package:journeys_app/view/screens/actions_screen.dart';
import 'package:journeys_app/view/screens/home_screen.dart';
import 'package:journeys_app/view/widgets/app_card.dart';
import 'package:journeys_app/view/widgets/app_dropdowm.dart';
import 'package:journeys_app/view/widgets/app_text_field.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../shapes.dart';
import '../widgets/app_snackbar.dart';

class CreateJourneyScreen extends StatefulWidget {
  const CreateJourneyScreen({super.key});

  @override
  State<StatefulWidget> createState() => CreateJourneyScreenState();
}

class CreateJourneyScreenState extends State<CreateJourneyScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthContorller = TextEditingController();

  double _daysCount = 1;
  String _destination = "";
  DateTime _selectedDate = DateTime.now();
  DateTime _startDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    _startDate = _selectedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 99999)));
    if (picked != null) {
      String month = picked.month.toString();
      String day = picked.day.toString();

      if (picked.month < 10) month = "0$month";
      if (picked.day < 10) day = "0$day";

      setState(() {
        _selectedDate = picked;
        _dateController.text = "$day";

        String m = "";

        switch (picked.month) {
          case 1:
            {
              m = "Января";
            }
            break;
          case 2:
            {
              m = "Февраля";
            }
            break;
          case 3:
            {
              m = "Марта";
            }
            break;
          case 4:
            {
              m = "Апреля";
            }
            break;
          case 5:
            {
              m = "Мая";
            }
            break;
          case 6:
            {
              m = "Июня";
            }
            break;
          case 7:
            {
              m = "Июля";
            }
            break;
          case 8:
            {
              m = "Августа";
            }
            break;
          case 9:
            {
              m = "Сентября";
            }
            break;
          case 10:
            {
              m = "Октября";
            }
            break;
          case 11:
            {
              m = "Ноября";
            }
            break;
          case 12:
            {
              m = "Декабря";
            }
            break;
        }
        _monthContorller.text = "$m";
      });
    }
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
                    Navigator.push(context, MaterialPageRoute(builder: (builder) => HomeScreen()));
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
        body: SingleChildScrollView(
          child: Column(
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
                onChanged: (text) {
                  _destination = text;
                },
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
                      textAlign: TextAlign.center,
                      onChanged: (text) {},
                      onTap: () {
                        _selectDate(context);
                      },
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
                      onTap: () {
                        _selectDate(context);
                      },
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
              Row(
                children: [
                  Expanded(
                    child: SfSlider(
                      min: 1,
                      max: 30,
                      interval: 1,
                      stepSize: 1,
                      value: _daysCount,
                      onChanged: (value) {
                        _daysCount = value;
                        setState(() {});
                      },
                      activeColor: Theme.of(context).primaryColor,
                      showDividers: true,
                      showLabels: true,
                      labelFormatterCallback: (actualValue, formattedText) {
                        return actualValue == _daysCount ? _daysCount.toInt().toString() : "";
                      },
                      thumbIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.mode_night_rounded,
                            color: Colors.white,
                            size: 13,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                color: AppColors.secondaryColor,
                child: InkWell(
                  onTap: () {
                    if (_destination.isNotEmpty && _selectedDate != _startDate) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => ActionsScreen(
                            journey: Journey(_destination, _selectedDate.toString(), _daysCount.toInt(), [], []),
                            isEditing: false,
                          ),
                        ),
                      );
                    } else {
                      final snackBar = SnackBar(
                          shape: AppShapes.roundedRectangleShape,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          behavior: SnackBarBehavior.floating,
                          content: const AppSnackBarContent(
                            label: "Заполните все поля!",
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
                          "Выбрать действия",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
