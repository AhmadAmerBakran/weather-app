import 'dart:convert';
import 'package:http/http.dart' as http;
import 'data_source.dart';
import 'models.dart';
import 'models/time_series.dart';
import 'package:location/location.dart';

class RealDataSource extends DataSource {
  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;


  Future<void> _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        throw Exception('Location service disabled');
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permission denied');
      }
    }
  }


  @override
  Future<WeeklyForecastDto> getWeeklyForecast() async {
    try {
      await _checkLocationPermission();
      final locationData = await location.getLocation();
      final apiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=${locationData.latitude}&longitude=${locationData.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=Europe%2FBerlin';
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        return WeeklyForecastDto.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<WeatherChartData> getChartData() async {
    try {
      await _checkLocationPermission();
      final location = await Location.instance.getLocation();
      final apiUrl = "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&daily=weather_code,temperature_2m_max,temperature_2m_min,wind_speed_10m_max&timezone=Europe%2FBerlin";
      final response = await http.get(Uri.parse(apiUrl));
      return WeatherChartData.fromJson(jsonDecode(response.body));
    } catch (e){
      rethrow;
    }

  }
}