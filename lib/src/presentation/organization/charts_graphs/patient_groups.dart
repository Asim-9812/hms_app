

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';

class ChartData {
  ChartData(this.grpName, this.num, this.color);
  final String grpName;
  final double num;
  final Color color;
}


class PatientGroups extends StatefulWidget {
  const PatientGroups({super.key});

  @override
  State<PatientGroups> createState() => _PatientGroupsState();
}

class _PatientGroupsState extends State<PatientGroups> {

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Diabetes', 25,ColorManager.primaryDark.withOpacity(0.8)),
      ChartData('Cancer', 38,Colors.yellow.withOpacity(0.7)),
      ChartData('Neurology', 34,ColorManager.red.withOpacity(0.5)),
      ChartData('Physio', 52,ColorManager.orange.withOpacity(0.6))
    ];
    return Container(
      width: 320,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Total Number of patients',style: getMediumStyle(color: Colors.black,fontSize: 20),),
                InkWell(
                    onTap: (){
                      setState(() {
                        tapped =!tapped;
                      });
                    },
                    child: FaIcon(tapped? CupertinoIcons.eye:CupertinoIcons.eye_slash,color: Colors.black,))
              ],
            ),
            SfCircularChart(

              legend: Legend(
                position: LegendPosition.top,
                overflowMode:LegendItemOverflowMode.wrap,
                isVisible: tapped,
                isResponsive: true
              ),
                series: <CircularSeries>[
                  // Render pie chart
                  PieSeries<ChartData, String>(
                    explode: true,
                    dataLabelMapper: (ChartData data,_)=>'${tapped?'':data.grpName} \n ${data.num.round().toString()}',

                    dataLabelSettings: DataLabelSettings(
                      overflowMode: OverflowMode.shift,
                      isVisible: true,
                      labelPosition:tapped? ChartDataLabelPosition.outside: ChartDataLabelPosition.inside,
                      connectorLineSettings: ConnectorLineSettings(
                        type: ConnectorType.line,
                      )
                    ),

                    selectionBehavior: SelectionBehavior(
                      enable: true,
                    ),
                    explodeGesture: ActivationMode.singleTap,
                      dataSource: chartData,
                      pointColorMapper:(ChartData data,  _) => data.color,
                      xValueMapper: (ChartData data, _) => data.grpName,
                      yValueMapper: (ChartData data, _) => data.num
                  )
                ]
            ),
            h20,
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary
                ),
                onPressed: (){},
                child: Text('View full information',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)
            )
          ],
        )
    );
  }
}
