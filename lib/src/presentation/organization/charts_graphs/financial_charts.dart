





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../dummy_datas/dummy_datas.dart';


class FinancialCharts extends StatefulWidget {
  const FinancialCharts({super.key});

  @override
  State<FinancialCharts> createState() => _DoctorChartsState();
}

class _DoctorChartsState extends State<FinancialCharts> {
  bool tapped = false;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 400;
    return Container(

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Income & expense',style: getMediumStyle(color: Colors.black,fontSize: 20),),
              InkWell(
                  onTap: (){
                    setState(() {
                      tapped =!tapped;
                    });
                  },
                  child: FaIcon(tapped? CupertinoIcons.eye:CupertinoIcons.eye_slash,color: Colors.black,))
            ],
          ),
          SfCartesianChart(

            legend: Legend(
              isVisible: tapped,
              position: LegendPosition.top,
            ),
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
              LineSeries<Map<String, dynamic>, String>(
                dataLabelSettings: DataLabelSettings(
                    isVisible: tapped,
                    color: ColorManager.primary,
                    labelIntersectAction: LabelIntersectAction.none
                ),
                dataSource: financialData,
                xValueMapper: (Map<String, dynamic> data, _) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
                yValueMapper: (Map<String, dynamic> data, _) => data['totalIncome'],
                name: 'Total Income',
              ),
              LineSeries<Map<String, dynamic>, String>(
                dataLabelSettings: DataLabelSettings(
                    isVisible: tapped,
                    color: ColorManager.red
                ),
                dataSource: financialData,
                xValueMapper: (Map<String, dynamic> data, _) => DateFormat('dd').format(DateTime.parse(data['date'])).toString(),
                yValueMapper: (Map<String, dynamic> data, _) => data['totalExpenses'],
                name: 'Total Expenses',
              ),
            ],
          ),

          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primary
              ),
              onPressed: (){},
              child: Text('View full information',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)
          )
        ],
      ),
    );
  }
}
