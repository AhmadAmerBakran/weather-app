import 'package:flutter/material.dart';
import 'package:community_charts_flutter/community_charts_flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'data_source.dart';
import 'models/time_series.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final axisColor = charts.MaterialPalette.gray.shadeDefault;
    return Scaffold(
      body: FutureBuilder<WeatherChartData>(
        future: context.read<DataSource>().getChartData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();
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
                // Tick and Label styling here.
                labelStyle: charts.TextStyleSpec(color: axisColor),
                // Change the line colors to match text color.
                lineStyle: charts.LineStyleSpec(color: axisColor),
              ),
              tickFormatterSpec: charts.BasicDateTimeTickFormatterSpec(
                    (datetime) => DateFormat("E").format(datetime), // Your custom tick format
              ),
            ),


            /// Assign a custom style for the measure axis.
            primaryMeasureAxis: charts.NumericAxisSpec(
              renderSpec: charts.GridlineRendererSpec(
                // Tick and Label styling here.
                labelStyle: charts.TextStyleSpec(color: axisColor),
                // Change the line colors to match text color.
                lineStyle: charts.LineStyleSpec(color: axisColor),
              ),
            ),

            animate: true,
            dateTimeFactory: const charts.LocalDateTimeFactory(),
            behaviors: [charts.SeriesLegend()],
          );
        },
      ),
    );
  }
}