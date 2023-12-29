import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../core/resources/value_manager.dart';

class PatientData {
  PatientData(this.x, this.y);
  final int x;
  final double y;
}


class PatientChart extends StatefulWidget {
  const PatientChart({super.key});

  @override
  State<PatientChart> createState() => _PatientChartState();
}

class _PatientChartState extends State<PatientChart> {

  bool tapped = false;

  @override
  Widget build(BuildContext context) {
    final List<PatientData> registeredPatient = [
      PatientData(10, 35),
      PatientData(11, 28),
      PatientData(12, 34),
      PatientData(13, 32),
      PatientData(14, 40)
    ];
    final List<PatientData> unregisteredPatient = [
      PatientData(10, 50),
      PatientData(11, 100),
      PatientData(12, 70),
      PatientData(13, 75),
      PatientData(14, 90)
    ];

    final List<Color> color = <Color>[];
    color.add(Colors.blue[50]!);
    color.add(Colors.blue[200]!);
    color.add(Colors.blue);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);

    final LinearGradient gradientColors =
    LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: color, stops: stops);





    return Container(


        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Total Number of patients',style: getMediumStyle(color: Colors.black,fontSize: 18),),
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
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  enablePinching: true,
                  zoomMode: ZoomMode.xy,

                ),
              legend: Legend(
                isVisible: true,
                position: LegendPosition.top,
                isResponsive: true
              ),
                series: <ChartSeries>[
                  // Renders area chart
                  AreaSeries<PatientData, int>(

                      dataLabelMapper: (PatientData data,_)=> data.y.round().toString(),
                    dataLabelSettings: DataLabelSettings(
                      color: Colors.blue,
                      isVisible: tapped,
                    ),
                    name: 'Unregistered',
                    gradient: gradientColors,
                      dataSource: unregisteredPatient,
                      xValueMapper: (PatientData data, _) => data.x,
                      yValueMapper: (PatientData data, _) => data.y
                  ),
                  AreaSeries<PatientData, int>(
                      dataLabelMapper: (PatientData data,_)=> data.y.round().toString(),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: tapped,
                        color: ColorManager.primaryDark
                      ),
                    name: 'Registered',
                    gradient: LinearGradient(
                        colors: [
                          ColorManager.primary.withOpacity(0.2),
                          ColorManager.primary.withOpacity(0.5),
                          ColorManager.primary.withOpacity(0.8),
                        ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter
                    ),
                      dataSource: registeredPatient,
                      xValueMapper: (PatientData data, _) => data.x,
                      yValueMapper: (PatientData data, _) => data.y
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
