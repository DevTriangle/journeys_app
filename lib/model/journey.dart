import 'package:journeys_app/model/app_action.dart';
import 'package:journeys_app/model/journey_item.dart';

class Journey {
  final String destination;
  final String dateTime;
  final int daysCount;
  final List<String> actions;
  List<JourneyItem> items;

  Journey(
    this.destination,
    this.dateTime,
    this.daysCount,
    this.actions,
    this.items,
  );

  factory Journey.fromJson(Map<String, dynamic> json) {
    List<JourneyItem> iList = [];

    json.forEach((key, value) {
      if (key == "items") {
        value.forEach((element) {
          iList.add(JourneyItem.fromJson(element));
        });
      }
    });

    return Journey(
      json["destination"],
      json["dateTime"],
      json["daysCount"],
      List<String>.from(json["actions"]),
      iList,
    );
  }

  Map toJson() => {
        "destination": destination,
        "dateTime": dateTime,
        "daysCount": daysCount,
        "actions": actions,
        "items": items,
      };
}
