import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/dummy_datas/dummy_datas.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class HealthChart extends StatefulWidget {
  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
          zoomMode: ZoomMode.xy,

        ),
        legend: Legend(
          isVisible: true,
          isResponsive: true,
          overflowMode: LegendItemOverflowMode.wrap
        ),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<Map<String, dynamic>, String>(
            dataSource: patientRecords,
            xValueMapper: (data, index) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
            yValueMapper: (data, index) => data['heartrate'],
            name: 'Heart Rate',
            dataLabelSettings: DataLabelSettings(
              isVisible: _isExpanded
            )
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: patientRecords,
            xValueMapper: (data, index) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
            yValueMapper: (data, index) => data['cholesterol level'],
            name: 'Cholesterol Level',
              dataLabelSettings: DataLabelSettings(
                  isVisible: _isExpanded
              )
          ),
          LineSeries<Map<String, dynamic>, String>(
            dataSource: patientRecords,
            xValueMapper: (data, index) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
            yValueMapper: (data, index) => data['sugar level'],
            name: 'Sugar Level',
              dataLabelSettings: DataLabelSettings(
                  isVisible: _isExpanded
              )
          ),
        ],
      ),
    );
  }
}


class BPChart extends StatefulWidget {
  @override
  State<BPChart> createState() => _BPChartState();
}

class _BPChartState extends State<BPChart> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      padding: EdgeInsets.all(16),
      child: SfCartesianChart(
        zoomPanBehavior: ZoomPanBehavior(
          enablePanning: true,
          enablePinching: true,
          zoomMode: ZoomMode.xy,

        ),
        legend: Legend(
            isVisible: true,
            isResponsive: true,
            overflowMode: LegendItemOverflowMode.wrap
        ),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          LineSeries<Map<String, dynamic>, String>(
              dataSource: patientRecords,
              xValueMapper: (data, index) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
              yValueMapper: (data, index) => data['bloodpressure high'],
              name: 'High',
              dataLabelSettings: DataLabelSettings(
                  isVisible: _isExpanded
              )
          ),
          LineSeries<Map<String, dynamic>, String>(
              dataSource: patientRecords,
              xValueMapper: (data, index) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
              yValueMapper: (data, index) => data['bloodpressure low'],
              name: 'Low',
              dataLabelSettings: DataLabelSettings(
                  isVisible: _isExpanded
              )
          ),

        ],
      ),
    );
  }
}


