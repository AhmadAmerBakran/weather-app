import 'package:flutter/material.dart';

import 'models.dart';


class WeeklyForecastList extends StatelessWidget {
  final WeeklyForecastDto weeklyForecast;

  const WeeklyForecastList({super.key, required this.weeklyForecast});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          final daily = weeklyForecast.daily!;
          final date = DateTime.parse(daily.time![index]);
          final weatherCode = WeatherCode.fromInt(daily.weatherCode![index]);
          final tempMax = daily.temperature2MMax![index];
          final tempMin = daily.temperature2MMin![index];
          final weekday = weekdayAsString(date);

          return Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 100.0,
                  width: 125.0,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        WeatherCode.getImagePath(daily.weatherCode![index]),
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              weekday,
                              style: textTheme.headlineMedium?.copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '${date.day}',
                          style: textTheme.titleMedium?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                    height: 100.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            weatherCode.description,
                            style: textTheme.bodyMedium,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '$tempMax° | $tempMin°C',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        childCount: weeklyForecast.daily?.time?.length ?? 0,
      ),
    );
  }
  String weekdayAsString(DateTime time) {
    return switch (time.weekday) {
      DateTime.monday => 'Monday',
      DateTime.tuesday => 'Tuesday',
      DateTime.wednesday => 'Wednesday',
      DateTime.thursday => 'Thursday',
      DateTime.friday => 'Friday',
      DateTime.saturday => 'Saturday',
      DateTime.sunday => 'Sunday',
      _ => ''
    };
  }
}