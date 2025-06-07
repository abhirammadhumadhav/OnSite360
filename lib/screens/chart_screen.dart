import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  late List<ProjectData> _chartData;
  late TooltipBehavior tooltipBehavior;
  @override
  void initState() {
    _chartData = getChartData();
    tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: SfCartesianChart(
          title: ChartTitle(
              text: 'Yearly project analysis',
              textStyle:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          legend: Legend(
              isVisible: true, textStyle: TextStyle(color: Colors.white)),
          tooltipBehavior: tooltipBehavior,
          series: [
            LineSeries<ProjectData, double>(
              dataSource: _chartData,
              name: 'Sales',
              xValueMapper: (ProjectData sales, _) => sales.year,
              yValueMapper: (ProjectData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(
                  isVisible: true, textStyle: TextStyle(color: Colors.white)),
              enableTooltip: true,
            )
          ],
          primaryXAxis: NumericAxis(
            edgeLabelPlacement: EdgeLabelPlacement.shift,
            labelStyle: TextStyle(color: Colors.white),
          ),
          primaryYAxis: NumericAxis(
            labelStyle: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  List<ProjectData> getChartData() {
    final List<ProjectData> chartData = [
      ProjectData(2015, 25),
      ProjectData(2016, 12),
      ProjectData(2017, 23),
      ProjectData(2018, 19),
      ProjectData(2019, 35),
    ];
    return chartData;
  }
}

class ProjectData {
  ProjectData(this.year, this.sales);
  final double year;
  final double sales;
}
