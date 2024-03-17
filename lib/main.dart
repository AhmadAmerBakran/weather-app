import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/real_data_source.dart';
import 'package:weather/weather_app.dart';

import 'data_source.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //Provider<DataSource>(create: (context) => FakeDataSource()),
        Provider<DataSource>(create: (context) => RealDataSource())
      ],
      child: const WeatherApp(),
    ),
  );
}