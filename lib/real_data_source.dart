import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_source.dart';
import 'models.dart';
import 'models/time_series.dart';
import 'package:location/location.dart';

class RealDataSource extends DataSource {


  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    final location = await Location.instance.getLocation();
    final apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min&wind_speed_unit=ms&timezone=Europe%2FBerlin';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return WeeklyForecastDto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Future<WeatherChartData> getChartData() async {
    final location = await Location.instance.getLocation();
    final apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max&timezone=Europe%2FBerlin";
    final response = await http.get(Uri.parse(apiUrl));
    return WeatherChartData.fromJson(jsonDecode(response.body));
  }
}