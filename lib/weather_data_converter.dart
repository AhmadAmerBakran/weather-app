import 'models/time_series.dart';

const _kTime = 'time';
const _kHourly = 'hourly';
const _kDaily = 'daily';
const _kUnits = 'units';

class WeatherDataConverter {
  static WeatherChartData convert(Map<String, dynamic> json) {
    return WeatherChartData(
      daily: convertGroup(json, group: _kDaily),
      hourly: convertGroup(json, group: _kHourly),
    );
  }

  static List<TimeSeriesVariable>? convertGroup(Map<String, dynamic> json,
      {required String group}) {
    if (!json.containsKey(group)) return null;

    // Find out what variables exist the group.
    final variables =
    (json[group] as Map<String, dynamic>).keys.where((key) => key != _kTime);

    return variables
        .map((variable) =>
    convertVariable(json, group: group, variable: variable)!)
        .toList();
  }

  static TimeSeriesVariable? convertVariable(Map<String, dynamic> json,
      {required String group, required String variable}) {
    if (!json.containsKey(group)) return null;

    // Find unit for variable
    final unit = json['${group}_$_kUnits']?[variable];

    // A data point is the value of variable at a specific point in time
    final values = List.generate(
      (json[group][_kTime] as List).length,
          (index) => TimeSeriesDatum(
        domain: DateTime.parse(json[group][_kTime][index]),
        measure: json[group][variable][index],
      ),
    );

    return TimeSeriesVariable(name: variable, unit: unit, values: values);
  }
}