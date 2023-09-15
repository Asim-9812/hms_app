


import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:weather/weather.dart';
import 'package:flutter/material.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../../test/test.dart';
import '../../../widgets/bmi.dart';
import '../../../widgets/bmr.dart';
import '../../../widgets/edd.dart';

class PatientUtilitiesPage extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  PatientUtilitiesPage(this.isWideScreen,this.isNarrowScreen);

  @override
  State<PatientUtilitiesPage> createState() => _PatientUtilitiesPageState();
}

class _PatientUtilitiesPageState extends State<PatientUtilitiesPage> {

  WeatherFactory wf = new WeatherFactory("5cd969bec67776d361b65b9fa9ef799b");

  Weather? weather ;
  String _status = '?', _steps = '?';

  bool _accelAvailable = false;
  int stepCount = 0;
  StreamSubscription<dynamic>? _accelerometerSubscription;
  bool isCounting = false;
  double previousY = 0.0;
  List<double> _accelData = List.filled(3, 0.0);
  final double stepThreshold = 2.5; // Adjust this value for your device

  int total_steps = 10000;
  int total_calories = 3000;


  @override
  void initState(){
    super.initState();
    _startListeningToAccelerometer();
    _checkAccelerometerStatus();
    _currentPos().then((value)=>_weatherDesc(value.latitude, value.longitude));

  }





  void _checkAccelerometerStatus() async {
    await SensorManager()
        .isSensorAvailable(Sensors.ACCELEROMETER)
        .then((result) {
      setState(() {
        _accelAvailable = result;
      });
    });
  }

  Future<void> _startListeningToAccelerometer() async {
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_FASTEST,
    );
    _accelerometerSubscription =
        stream.listen((event) {
          // Process accelerometer data and update step count
          _updateStepCount(event);
        });
  }

  void _stopListeningToAccelerometer() {
    _accelerometerSubscription?.cancel();
  }

  void _updateStepCount(event) {
    _accelData = event.data;
    double currentY = _accelData[1];
    if (isCounting) {
      // Check for a peak (step up)
      if (currentY > previousY && currentY - previousY > stepThreshold) {
        setState(() {
          stepCount++;
          isCounting = false;
        });
        print('counted');
      }
    } else {
      // Check for a valley (step down)
      if (currentY < previousY && previousY - currentY > stepThreshold) {
        isCounting = true;
      }
    }
    previousY = currentY;
  }



  Future<Position> _currentPos() async {
    try{
      final _pos = await Geolocator.getCurrentPosition();
      return _pos;
    } on GeolocatorPlatform catch(error){
      print('$error');
      Position _pos1 = Position(longitude: 0.0, latitude: 0.0, timestamp: null, accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
      return _pos1;
    }


  }



  Future<Weather> _weatherDesc(double lat,double long) async{

    Weather w = await wf.currentWeatherByLocation(lat, long);

    setState(() {
      weather = w;
    });

    print(w);
    return w;



  }

  @override
  void dispose() {
    _stopListeningToAccelerometer();
    super.dispose();
  }

  double estimateCaloriesBurned(int steps) {
    double weightInKg = 80;
    double metValue = 3.5;
    // Replace these values with your own data or use user input
    const double stepsPerMile = 2000;

    // Calculate calories burned using MET method
    double caloriesBurned = (metValue * weightInKg) * (steps / stepsPerMile);

    return caloriesBurned;
  }



  @override
  Widget build(BuildContext context) {

    return FadeIn(
      duration: Duration(milliseconds: 500),
      child: Scaffold(
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
              h20,
              _buildGridview(),
              h20,
              h20,
              FadeInUp(
                  duration: Duration(milliseconds: 700),
                  child: _buildCalculatorBody())

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridview(){
    return GridView(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 16/28,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 12.h

      ),
      children: [
        _buildWeatherBody(),
        FadeInRight(
            duration: Duration(milliseconds: 700),
            child: _buildCalorieBody())
      ],
    );
  }

  Widget _buildCalorieBody(){
    double caloriesBurned = estimateCaloriesBurned(stepCount);
    int remaining = total_steps - stepCount;
    int remainingCalories = total_calories - caloriesBurned.round();
    List<double> total = [stepCount.toDouble() , remaining.toDouble() ];
    List<double> totalCalories = [caloriesBurned , remainingCalories.toDouble() ];
    Map<String, double> dataMap = {
      "progress": total[0],
      "remained": total[1],
    };
    Map<String, double> dataCalories = {
      "progress": totalCalories[0],
      "remained": totalCalories[1],
    };
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: ColorManager.black.withOpacity(0.5),
              width: 0.5
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            // color: Colors.red,
            // height: 150.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.personWalking,color: ColorManager.primary,size:widget.isWideScreen? 20 :20.sp,),
                    w10,
                    Text('Walking',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 20 :20.sp),)
                  ],
                ),
                Container(
                  height: 100.h,
                  child: Stack(
                    children: [
                      Center(
                        child: PieChart(

                          colorList: [ColorManager.primary, ColorManager.textGrey.withOpacity(0.5)],
                          chartValuesOptions: ChartValuesOptions(

                            showChartValuesOutside: true,
                            chartValueStyle: getRegularStyle(color: ColorManager.black),
                            showChartValues: false,
                          ),
                          legendOptions:
                          LegendOptions(showLegends: false),
                          chartRadius: widget.isWideScreen? 100 :100.sp,
                          ringStrokeWidth: widget.isWideScreen? 7:7.w,
                          chartType: ChartType.ring,
                          dataMap: dataMap,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(stepCount.round().toString(),style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 20 :20.sp),),
                            Text('Steps Taken',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen? 20 :16.sp),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.red,
            // height: 150.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.fire,color: ColorManager.red.withOpacity(0.6),size: widget.isWideScreen? 20 :20.sp,),
                    w10,
                    Text('Calories',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 20 :20.sp),)
                  ],
                ),
                Container(
                  height: 100.h,
                  child: Stack(
                    children: [
                      Center(
                        child: PieChart(

                          colorList: [ColorManager.red.withOpacity(0.5), ColorManager.textGrey.withOpacity(0.5)],
                          chartValuesOptions: ChartValuesOptions(

                            showChartValuesOutside: true,
                            chartValueStyle: getRegularStyle(color: ColorManager.black),
                            showChartValues: false,
                          ),
                          legendOptions:
                          LegendOptions(showLegends: false),
                          chartRadius: widget.isWideScreen? 100 :100.sp,
                          ringStrokeWidth: widget.isWideScreen? 7:7.w,
                          chartType: ChartType.ring,
                          dataMap: dataCalories,
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(caloriesBurned.toPrecision(1).toString(),style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 20 :20.sp),),
                            Text('Calories\n burned',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen? 12 :12.sp),)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildWeatherBody() {
    return Container(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FadeInLeft(
            duration: Duration(milliseconds: 500),
            child: _buildWeather(
                color: ColorManager.primary.withOpacity(0.1),
                icon: Icons.thermostat_outlined,
                name: 'Temperature',
                result: weather != null?'${weather!.tempMax}':'no data',
                iconColor: ColorManager.primaryOpacity80
            ),
          ),
          FadeInLeft(
            duration: Duration(milliseconds: 700),
            child: _buildWeather(
              color: ColorManager.lightBlueAccent.withOpacity(0.5),
              iconColor: ColorManager.blueText.withOpacity(0.5),
              icon: CupertinoIcons.cloud,
              name: 'Weather',
              result: weather != null?'${weather!.weatherDescription}':'no data',
            ),
          ),
          FadeInLeft(
            duration: Duration(milliseconds: 900),
            child: _buildWeather(
                color: ColorManager.yellowFellow.withOpacity(0.3),
                iconColor: ColorManager.yellowFellow,
                icon: CupertinoIcons.sun_dust,
                name: 'Sunrise',
                result: weather!=null?'${DateFormat('hh:mm a').format(weather!.sunrise!)}':'no data'
            ),
          ),

        ],
      ),
    );
  }


  Widget _buildWeather({
    required Color color,
    required Color iconColor,
    required IconData icon,
    required String name,
    required String result
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
      height: widget.isWideScreen? 150.h:100.h,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: ColorManager.black.withOpacity(0.5),
              width: 0.5
          )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(icon,color: iconColor,size: widget.isWideScreen? 20:20.sp,),
              w10,
              Text('$name',style: getRegularStyle(color: ColorManager.black.withOpacity(0.5),fontSize: widget.isWideScreen?20:16.sp),)
            ],
          ),
          h10,
          weather!=null? Text('$result',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?20:16.sp),maxLines: 1,)
              : SpinKitThreeBounce(
            color: ColorManager.iconGrey,
            size: 20,
          ),
        ],
      ),

    );
  }


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
          )
      ),
      child: Center(
        child: ListTile(
          onTap: onTap,
          contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
          leading: Image.asset('assets/icons/$icon.png',width: widget.isWideScreen? 40:40.w,height: widget.isWideScreen? 40:40.h,) ,


          title: Text('$name',style: getMediumStyle(color: ColorManager.black,fontSize: name.length <= 6? widget.isWideScreen? 24:20.sp:widget.isWideScreen? 18:16.sp),),
          subtitle: Text('Calculator',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 14:10.sp),),
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Calculators',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isWideScreen?28:24.sp),),
              w10,
              Container(
                width: 260.w,
                child: Divider(
                  thickness: 0.5.w,
                  color: ColorManager.black.withOpacity(0.5),
                ),
              )
            ],
          ),
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
                  icon: 'bmi',
                  name: 'BMI',
                  onTap: ()=>Get.to(()=>BMI())
              ),
              _buildCalculators(
                  icon: 'bmr',
                  name: 'BMR',
                  onTap: ()=>Get.to(()=>BMR())
              ),
              _buildCalculators(
                  icon: 'calories',
                  name: 'Calories',
                  onTap: (){}
              ),
              _buildCalculators(
                  icon: 'due-date',
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


}
