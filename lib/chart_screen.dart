import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'data_source.dart';
import 'models/time_series.dart';
import 'package:location/location.dart';


class ChartScreen extends StatefulWidget {
  const ChartScreen({Key? key}) : super(key: key);

  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late Future<WeatherChartData> _chartDataFuture;
  bool _permissionRequested = false;


  @override
  void initState() {
    super.initState();
    _requestLocationPermissionAndLoadData();
  }


  Future<void> _requestLocationPermissionAndLoadData() async {
    final hasPermission = await _requestLocationPermission();
    if (hasPermission) {
      _loadChartData();
    } else if (!_permissionRequested) {
      _permissionRequested = true;
      _showPermissionDialog();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Needed'),
          content: const Text('This app needs location access to display the chart data.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Settings'),
              onPressed: () {
                AppSettings.openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }

  void _loadChartData() {
    setState(() {
      _chartDataFuture = context.read<DataSource>().getChartData();
    });
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


  @override
  Widget build(BuildContext context) {
    final axisColor = charts.MaterialPalette.gray.shadeDefault;
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<WeatherChartData>(
          future: _chartDataFuture,
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Failed to load chart data: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _requestLocationPermissionAndLoadData,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No chart data available'));
            }
            final variables = snapshot.data!.daily!;
            return charts.TimeSeriesChart(
              [
                for (final variable in variables)
                  charts.Series<TimeSeriesDatum, DateTime>(
                    id: '${variable.name} ${variable.unit}',
                    domainFn: (datum, _) => datum.domain,
                    measureFn: (datum, _) => datum.measure,
                    data: variable.values,
                  ),
              ],
              domainAxis: charts.DateTimeAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                  labelStyle: charts.TextStyleSpec(color: axisColor),
                  lineStyle: charts.LineStyleSpec(color: axisColor),
                ),
                tickFormatterSpec: charts.BasicDateTimeTickFormatterSpec(
                      (datetime) =>
                      DateFormat("E").format(
                          datetime),
                ),
              ),

              /// Assign a custom style for the measure axis.
              primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                  labelStyle: charts.TextStyleSpec(color: axisColor),
                  lineStyle: charts.LineStyleSpec(color: axisColor),
                ),
              ),

              animate: true,
              dateTimeFactory: const charts.LocalDateTimeFactory(),
              behaviors: [charts.SeriesLegend()],
            );
          },
        ),
      ),
    );
  }
}