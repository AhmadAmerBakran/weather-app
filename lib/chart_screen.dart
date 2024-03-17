import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
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
  final Map<String, bool> _seriesVisibility = {};

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

  void _loadChartData() {
    setState(() {
      _chartDataFuture = context.read<DataSource>().getChartData();
    });
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
    final axisColor = charts.MaterialPalette.gray.shadeDefault;

    final List<Color> seriesColors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.purple,
    ];


    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<WeatherChartData>(
          future: _chartDataFuture,
          builder: (BuildContext context, AsyncSnapshot<WeatherChartData> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
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
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No chart data available'));
            }

            final variables = snapshot.data!.daily!;
            if (_seriesVisibility.isEmpty) {
              for (var variable in variables) {
                _seriesVisibility[variable.name] = true;
              }
            }

            final seriesList = variables.asMap().entries.map((entry) {
              return charts.Series<TimeSeriesDatum, DateTime>(
                id: '${entry.value.name}',
                colorFn: (_, __) =>
                    charts.ColorUtil.fromDartColor(seriesColors[entry.key % seriesColors.length]),
                domainFn: (TimeSeriesDatum datum, _) => datum.domain,
                measureFn: (TimeSeriesDatum datum, _) => datum.measure,
                data: _seriesVisibility[entry.value.name] == true ? entry.value.values : [],
              );
            }).toList();

            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(8.0),
                    child: charts.TimeSeriesChart(
                      seriesList,
                      animate: true,
                      dateTimeFactory: const charts.LocalDateTimeFactory(),
                      domainAxis: charts.DateTimeAxisSpec(
                        renderSpec: charts.SmallTickRendererSpec(
                          labelStyle: charts.TextStyleSpec(color: axisColor),
                          lineStyle: charts.LineStyleSpec(color: axisColor),
                        ),
                      ),
                      primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                          labelStyle: charts.TextStyleSpec(color: axisColor),
                          lineStyle: charts.LineStyleSpec(color: axisColor),
                        ),
                      ),
                    ),
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8.0,
                    children: variables.asMap().entries.map((entry) {
                      final variableName = entry.value.name;
                      final color = seriesColors[entry.key % seriesColors.length];
                      return FilterChip(
                        label: Text(variableName),
                        selected: _seriesVisibility[variableName]!,
                        onSelected: (bool selected) {
                          setState(() {
                            _seriesVisibility[variableName] = selected;
                          });
                        },
                        selectedColor: color,
                        checkmarkColor: Colors.white,
                        backgroundColor: color.withOpacity(0.5),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}