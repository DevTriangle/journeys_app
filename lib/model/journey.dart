import 'package:journeys_app/model/app_action.dart';

class Journey {
  final String destination;
  final String dateTime;
  final int daysCount;
  final List<String> actions;

  Journey(
    this.destination,
    this.dateTime,
    this.daysCount,
    this.actions,
  );

  factory Journey.fromJson(Map<String, dynamic> json) {
    return Journey(
      json["destination"],
      json["dateTime"],
      json["daysCount"],
      List<String>.from(json["actions"]),
    );
  }

  Map toJson() => {
        "destination": destination,
        "dateTime": dateTime,
        "daysCount": daysCount,
        "actions": actions,
      };
}
