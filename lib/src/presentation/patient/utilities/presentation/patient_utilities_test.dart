


import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/presentation/organization/organization_dashboard/presentation/org_homepage.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sync;
// import 'package:weather/weather.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../widgets/bmi.dart';
import '../../../widgets/bmr.dart';
import '../../../widgets/edd.dart';
import '../../calories/presentation/testCalories.dart';

class PatientUtilities extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  PatientUtilities(this.isWideScreen,this.isNarrowScreen);

  @override
  State<PatientUtilities> createState() => _PatientUtilitiesState();
}

class _PatientUtilitiesState extends State<PatientUtilities> {


  // WeatherFactory wf = new WeatherFactory("5cd969bec67776d361b65b9fa9ef799b");
  //
  // Weather? weather ;
  //
  //
  // @override
  // void initState(){
  //   super.initState();
  //   _currentPos().then((value)=>_weatherDesc(value.latitude, value.longitude));
  //
  // }
  //
  // Future<Position> _currentPos() async {
  //   try{
  //     final _pos = await Geolocator.getCurrentPosition();
  //     return _pos;
  //   } on GeolocatorPlatform catch(error){
  //     Position _pos1 = Position(longitude: 0.0, latitude: 0.0, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
  //     return _pos1;
  //   }
  //
  //
  // }
  //
  //
  //
  // Future<Weather> _weatherDesc(double lat,double long) async{
  //
  //   Weather w = await wf.currentWeatherByLocation(lat, long);
  //
  //   setState(() {
  //     weather = w;
  //   });
  //   return w;
  //
  // }

  @override
  Widget build(BuildContext context) {
    Map<String,double> calories = {
      "today" : 2500-500,
      "burnt" : 500
    };
    return Scaffold(
      backgroundColor: ColorManager.dotGrey.withOpacity(0.01),
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 1,
        title: Text('Utilities',style: getRegularStyle(color: ColorManager.black),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // h20,
            // Padding(
            //   padding:  EdgeInsets.symmetric(horizontal: 18.w),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
            //           decoration: BoxDecoration(
            //               color: ColorManager.primary.withOpacity(0.1),
            //               borderRadius: BorderRadius.circular(12),
            //               border: Border.all(
            //                   color: ColorManager.black.withOpacity(0.5),
            //                   width: 0.5
            //               )
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   FaIcon(Icons.thermostat_outlined,color:ColorManager.primaryOpacity80,size: widget.isWideScreen? 20:20.sp,),
            //                   w10,
            //                   Text('Temperature',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen?20:16.sp),)
            //                 ],
            //               ),
            //               h10,
            //               weather!=null? Text(weather != null?'${weather!.tempMax}':'no data',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?20:16.sp),maxLines: 1,)
            //                   : SpinKitThreeBounce(
            //                 color: ColorManager.iconGrey,
            //                 size: 20,
            //               ),
            //             ],
            //           ),
            //
            //         ),
            //       ),
            //       w10,
            //       Expanded(
            //         child: Container(
            //           padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
            //           decoration: BoxDecoration(
            //               color: ColorManager.lightBlueAccent.withOpacity(0.5),
            //               borderRadius: BorderRadius.circular(12),
            //               border: Border.all(
            //                   color: ColorManager.black.withOpacity(0.5),
            //                   width: 0.5
            //               )
            //           ),
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: [
            //                   FaIcon(CupertinoIcons.cloud,color: ColorManager.blueText.withOpacity(0.5),size: widget.isWideScreen? 20:20.sp,),
            //                   w10,
            //                   Text('Weather',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen?20:16.sp),)
            //                 ],
            //               ),
            //               h10,
            //               weather!=null? Text(weather != null?'${weather!.weatherDescription}':'no data',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?20:16.sp),maxLines: 1,)
            //                   : SpinKitThreeBounce(
            //                 color: ColorManager.iconGrey,
            //                 size: 20,
            //               ),
            //             ],
            //           ),
            //
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // ),
            // h20,
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 18.w),
            //   child: Container(
            //     height: 180,
            //     child: Row(
            //       children: [
            //         Expanded(
            //           child: InkWell(
            //             onTap: ()=>Get.to(()=>UserProfileForm()),
            //             child: Container(
            //               padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
            //               decoration: BoxDecoration(
            //                   // color: ColorManager.blue.withOpacity(0.2),
            //                   borderRadius: BorderRadius.circular(12),
            //                   border: Border.all(
            //                       color: ColorManager.black.withOpacity(0.5),
            //                       width: 0.5
            //                   )
            //               ),
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 crossAxisAlignment: CrossAxisAlignment.center,
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment: MainAxisAlignment.center,
            //                     children: [
            //                       FaIcon(CupertinoIcons.gauge,color:ColorManager.orange,size: widget.isWideScreen? 20:20.sp,),
            //                       w10,
            //                       Text('Total Calories',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen?24:20.sp),)
            //                     ],
            //                   ),
            //                   h10,
            //
            //                   PieChart(
            //                     animationDuration: Duration(seconds: 1),
            //                     baseChartColor: Colors.transparent,
            //                     totalValue: 3000,
            //                     emptyColor: ColorManager.dotGrey,
            //                     colorList: [ColorManager.orange,ColorManager.blueText],
            //                     initialAngleInDegree: 270,
            //                     centerText: '${calories['today']!.round()}\nCalories',
            //                     centerTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
            //                     dataMap: calories,
            //                     legendOptions: LegendOptions(
            //                       showLegends: false,
            //                       showLegendsInRow: false
            //                     ),
            //                     ringStrokeWidth: 8,
            //                     chartType: ChartType.ring,
            //                     chartValuesOptions: ChartValuesOptions(
            //                       chartValueBackgroundColor: Colors.transparent,
            //                       showChartValues: false
            //                     ),
            //                     chartRadius: 100,
            //
            //                   ),
            //
            //
            //                 ],
            //               ),
            //
            //             ),
            //           ),
            //         ),
            //         w10,
            //         Expanded(
            //
            //           child: Column(
            //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //             children: [
            //               Container(
            //                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 24.h),
            //                 decoration: BoxDecoration(
            //                   // color: ColorManager.blue.withOpacity(0.2),
            //                     borderRadius: BorderRadius.circular(12),
            //                     border: Border.all(
            //                         color: ColorManager.black.withOpacity(0.5),
            //                         width: 0.5
            //                     )
            //                 ),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Row(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             FaIcon(FontAwesomeIcons.burger,color:ColorManager.orange,size: widget.isWideScreen? 20:20.sp,),
            //                             w10,
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 Text('Calories Intake',style: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: widget.isWideScreen?14:12.sp),),
            //                                 Text('2500',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?24:20.sp),),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                         FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.orange,size: widget.isWideScreen? 16:16.sp,),
            //                       ],
            //                     ),
            //                     h10,
            //                     LinearProgressBar(
            //                         maxSteps: 3800,
            //                         currentStep: 2500,
            //                         progressColor: ColorManager.greenOpacity5,
            //                         backgroundColor: ColorManager.dotGrey.withOpacity(0.7)
            //                     )
            //
            //
            //                   ],
            //                 ),
            //
            //               ),
            //               Container(
            //                 padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 24.h),
            //                 decoration: BoxDecoration(
            //                   // color: ColorManager.blue.withOpacity(0.2),
            //                     borderRadius: BorderRadius.circular(12),
            //                     border: Border.all(
            //                         color: ColorManager.black.withOpacity(0.5),
            //                         width: 0.5
            //                     )
            //                 ),
            //                 child: Column(
            //                   mainAxisAlignment: MainAxisAlignment.start,
            //                   crossAxisAlignment: CrossAxisAlignment.center,
            //                   children: [
            //                     Row(
            //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Row(
            //                           crossAxisAlignment: CrossAxisAlignment.start,
            //                           children: [
            //                             FaIcon(FontAwesomeIcons.dumbbell,color:ColorManager.blueText,size: widget.isWideScreen? 20:20.sp,),
            //                             w10,
            //                             Column(
            //                               crossAxisAlignment: CrossAxisAlignment.start,
            //                               children: [
            //                                 Text('Calories Burned',style: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: widget.isWideScreen?14:12.sp),),
            //                                 Text('500',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?24:20.sp),),
            //                               ],
            //                             ),
            //                           ],
            //                         ),
            //                         FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.blueText,size: widget.isWideScreen? 16:16.sp,),
            //                       ],
            //                     ),
            //                     h10,
            //                     LinearProgressBar(
            //                         maxSteps: 1800,
            //                         currentStep: 500,
            //                         progressColor: ColorManager.blueText,
            //                         backgroundColor: ColorManager.dotGrey.withOpacity(0.7)
            //                     )
            //
            //
            //                   ],
            //                 ),
            //
            //               ),
            //             ],
            //           ),
            //         ),
            //
            //       ],
            //     ),
            //   ),
            // ),

            h20,
            _patientStat(context),

            _buildCalculatorBody()

          ],
        ),
      ),
    );
  }


  // Widget _buildWeather({
  //   required Color color,
  //   required Color iconColor,
  //   required IconData icon,
  //   required String name,
  //   required String result
  // }) {
  //   return Expanded(
  //     child: Container(
  //       padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
  //       height: widget.isWideScreen? 150.h:100.h,
  //       decoration: BoxDecoration(
  //           color: color,
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //               color: ColorManager.black.withOpacity(0.5),
  //               width: 0.5
  //           )
  //       ),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.start,
  //             children: [
  //               FaIcon(icon,color: iconColor,size: widget.isWideScreen? 20:20.sp,),
  //               w10,
  //               Text('$name',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen?20:16.sp),)
  //             ],
  //           ),
  //           h10,
  //           weather!=null? Text('$result',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?20:16.sp),maxLines: 1,)
  //               : SpinKitThreeBounce(
  //             color: ColorManager.iconGrey,
  //             size: 20,
  //           ),
  //         ],
  //       ),
  //
  //     ),
  //   );
  // }
  //
  // Widget _buildWeatherBody() {
  //   return Row(
  //     children: [
  //       FadeInLeft(
  //         duration: Duration(milliseconds: 500),
  //         child: _buildWeather(
  //             color: ColorManager.primary.withOpacity(0.1),
  //             icon: Icons.thermostat_outlined,
  //             name: 'Temperature',
  //             result: weather != null?'${weather!.tempMax}':'no data',
  //             iconColor: ColorManager.primaryOpacity80
  //         ),
  //       ),
  //       w10,
  //       FadeInLeft(
  //         duration: Duration(milliseconds: 700),
  //         child: _buildWeather(
  //           color: ColorManager.lightBlueAccent.withOpacity(0.5),
  //           iconColor: ColorManager.blueText.withOpacity(0.5),
  //           icon: CupertinoIcons.cloud,
  //           name: 'Weather',
  //           result: weather != null?'${weather!.weatherDescription}':'no data',
  //         ),
  //       ),
  //
  //     ],
  //   );
  // }



  Widget _buildCalculators({
    required String icon,
    required String name,
    required VoidCallback onTap,
  }){
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: ColorManager.black.withOpacity(0.8),
              width: 0.5
          ),
        color: ColorManager.white
      ),
      child: Center(
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          leading: Image.asset('assets/icons/$icon.png',width: widget.isWideScreen? 40:40.w,height: widget.isWideScreen? 40:40.h,) ,


          title: Text('$name',style: getMediumStyle(color: ColorManager.black,fontSize: name.length <= 6? widget.isWideScreen? 24:20.sp:widget.isWideScreen? 18:16.sp),),
          subtitle: Text('Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 14:12.sp),),
          trailing: FaIcon(Icons.chevron_right,color: ColorManager.black.withOpacity(0.5),),
        ),
      ),
    );

  }

  Widget _buildCalculatorBody(){
    return Container(
      // color: Colors.red,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          //     Text('Calculators',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?28:24.sp),),
          //     w10,
          //     Container(
          //       width: 260.w,
          //       child: Divider(
          //         thickness: 0.5.w,
          //         color: ColorManager.black.withOpacity(0.5),
          //       ),
          //     )
          //   ],
          // ),
          h20,
          GridView(
            padding: EdgeInsets.zero,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 16/7
            ),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              _buildCalculators(
                  icon: 'bmi2',
                  name: 'BMI',
                  onTap: ()=>Get.to(()=>BMI())
              ),
              _buildCalculators(
                  icon: 'bmr3',
                  name: 'BMR',
                  onTap: ()=>Get.to(()=>BMR())
              ),
              _buildCalculators(
                  icon: 'due-date2',
                  name: 'Due Date',
                  onTap: ()=>Get.to(()=>EDD())
              )
            ],
          ),
          h100,
        ],
      ),
    );
  }


  _patientStat(BuildContext context){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width*0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: ColorManager.red.withOpacity(0.15)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.heartPulse,color: ColorManager.red.withOpacity(0.5),size: 20.sp,),
                          w10,
                          Text('Heart Rate',style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),)
                        ],
                      ),
                      h10,
                      Text('120 bpm',style: getMediumStyle(color: ColorManager.black,fontSize: 16.sp),),
                      h20,
                      Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12.sp),)
                    ],

                  ),
                ),
              ),
              w10,
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width*.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: ColorManager.primary.withOpacity(0.15)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.heartCircleBolt,color: ColorManager.primaryDark.withOpacity(0.5),size: 20.sp,),
                          w10,
                          Text('Blood Pressure',style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),)
                        ],
                      ),
                      h10,
                      Text('120/80 mmHg',style: getMediumStyle(color: ColorManager.black,fontSize: 16.sp),),
                      h20,
                      Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12.sp),)
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
        h10,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width*.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: ColorManager.blue.withOpacity(0.15)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(CupertinoIcons.graph_circle_fill,color: ColorManager.blue.withOpacity(0.5),size: 20.sp,),
                          w10,
                          Text('Cholesterol',style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),)
                        ],
                      ),
                      h10,
                      Text('97 mg/dl',style: getMediumStyle(color: ColorManager.black,fontSize: 16.sp),),
                      h20,
                      Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12.sp),)
                    ],

                  ),
                ),
              ),
              w10,
              Expanded(
                child: Container(
                  // width: MediaQuery.of(context).size.width*.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),

                      color: ColorManager.orange.withOpacity(0.15)
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 18.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FaIcon(FontAwesomeIcons.heartCircleCheck,color: ColorManager.orange.withOpacity(0.5),size: 20.sp,),
                          w10,
                          Text('Sugar',style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),)
                        ],
                      ),
                      h10,
                      Text('90 mg/dl',style: getMediumStyle(color: ColorManager.black,fontSize:16.sp),),
                      h20,
                      Text('2023-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12.sp),)
                    ],

                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

}

