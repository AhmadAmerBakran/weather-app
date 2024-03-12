import 'dart:convert';

import 'package:flutter/services.dart';

import 'models.dart';

abstract class DataSource {
  Future<WeeklyForecastDto> getWeeklyForecast();
}

class FakeDataSource extends DataSource {
  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final json = await rootBundle.loadString("assets/daily_weather.json");
    return WeeklyForecastDto.fromJson(jsonDecode(json));
  }
}