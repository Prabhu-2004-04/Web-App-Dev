import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoistureChart extends StatelessWidget {
  final List<double> moistureData;

  MoistureChart({required this.moistureData});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: moistureData
                .asMap()
                .map((index, value) => MapEntry(index, FlSpot(index.toDouble(), value)))
                .values
                .toList(),
            isCurved: true,
            color: Colors.blue,  // Correct usage of predefined blue color
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
