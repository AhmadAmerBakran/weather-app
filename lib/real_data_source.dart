import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_source.dart';
import 'models.dart';

class RealDataSource extends DataSource {
  final String apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=55.4703&longitude=8.4519&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin";


  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return WeeklyForecastDto.fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load weather data');
    }
  }
}