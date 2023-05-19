import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:journeys_app/model/weather_item.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel extends ChangeNotifier {
  List<WeatherItem> weatherList = [];

  Future<WeatherItem> getCurrentWeather(String location) async {
    WeatherItem weatherItem;

    try {
      http.Response response = await http.get(Uri.parse(
          "https://nominatim.openstreetmap.org/search?q=${location.replaceAll('&', '')}&format=json"));

      http.Response wResponse = await http.get(Uri.parse(
          "https://api.open-meteo.com/v1/forecast?latitude=${double.parse(jsonDecode(response.body)[0]["lat"])}&longitude=${double.parse(jsonDecode(response.body)[0]["lon"])}&current_weather=true"));

      weatherItem = WeatherItem(
        location,
        jsonDecode(wResponse.body)["current_weather"]["temperature"],
      );

      return weatherItem;
    } catch (e) {
      print(e);

      return WeatherItem(location, 0);
    }
  }

  Future<List<WeatherItem>> getWeatherList() async {
    weatherList.clear();

    SharedPreferences shared = await SharedPreferences.getInstance();

    List<String> wList = [];

    if (shared.getString("weatherList") != null) {
      wList.addAll(
          List<String>.from(jsonDecode(shared.getString("weatherList")!)));
    }

    for (var w in wList) {
      weatherList.add(await getCurrentWeather(w));
    }

    return weatherList;
  }
}
