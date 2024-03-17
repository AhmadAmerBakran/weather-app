import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/weather_sliver_app_bar.dart';
import 'package:weather/weekly_forecast_list.dart';
import 'package:app_settings/app_settings.dart';
import 'package:location/location.dart';


import 'data_source.dart';
import 'models.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({Key? key}) : super(key: key);

  @override
  _WeeklyForecastScreenState createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState extends State<WeeklyForecastScreen> {
  late Future<WeeklyForecastDto> _forecastFuture;

  @override
  void initState() {
    super.initState();
    _forecastFuture = loadForecast();
  }

  Future<WeeklyForecastDto> loadForecast() {
    return context.read<DataSource>().getWeeklyForecast();
  }

  Future<bool> _requestLocationPermission() async {
    final location = Location();
    final serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      final serviceEnabledRequest = await location.requestService();
      if (!serviceEnabledRequest) return false;
    }

    var permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return false;
    }

    return true;
  }

  Future<void> _reloadForecast() async {
    final hasPermission = await _requestLocationPermission();
    if (hasPermission) {
      setState(() {
        _forecastFuture = loadForecast();
      });
    } else {
      showPermissionDialog(context);
    }
  }

  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Needed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This app needs location access to function correctly.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                AppSettings.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _reloadForecast,
        child: CustomScrollView(
          slivers: <Widget>[
            const WeatherSliverAppBar(),
            FutureBuilder<WeeklyForecastDto>(
              future: _forecastFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasData) {
                  return WeeklyForecastList(weeklyForecast: snapshot.data!);
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Failed to load data: ${snapshot.error}',
                              style: TextStyle(color: Theme.of(context).colorScheme.error),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _reloadForecast,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text('No data available'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}