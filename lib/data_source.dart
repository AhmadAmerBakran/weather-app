import 'dart:convert';

import 'package:flutter/services.dart';

import 'models.dart';

class FakeDataSource {
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
}