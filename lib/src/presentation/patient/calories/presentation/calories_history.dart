import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/resources/value_manager.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../domain/model/calories_model.dart';
import 'add_previous_days.dart';
import 'calories_all_records.dart';

class CaloriesHistory extends StatefulWidget {
  final List<CaloriesTrackingModel> data;
  final UserInfoCalories user;
  CaloriesHistory({required this.data,required this.user});

  @override
  State<CaloriesHistory> createState() => _CaloriesHistoryState();
}

class _CaloriesHistoryState extends State<CaloriesHistory> {


  bool isIntakeLabelVisible = false;
  bool isBurnedLabelVisible = false;
  bool isTotalLabelVisible = false;
  bool isIntakeVisible = true;
  bool isBurnedVisible = true;
  bool isTotalVisible = true;


  late List<CaloriesTrackingModel> expandedData;
  late List<CaloriesTrackingModel> graphData;



  late Box<CaloriesTrackingModel> caloriesInfoBox;
  late ValueListenable<Box<CaloriesTrackingModel>> caloriesInfoBoxListenable;



  @override
  void initState() {
    super.initState();


    caloriesInfoBox = Hive.box<CaloriesTrackingModel>('saved_userCalories_box');

    caloriesInfoBoxListenable = caloriesInfoBox.listenable();

    caloriesInfoBoxListenable.addListener(_onHiveBoxChanged);

    expandedData = _expandData(caloriesInfoBox.values.toList());
    graphData = _graphData(caloriesInfoBox.values.toList());

  }



  List<CaloriesTrackingModel> _expandData(List<CaloriesTrackingModel> data) {
    List<CaloriesTrackingModel> expandedData = [];
    final newData =caloriesInfoBox.values.toList();

    if (newData.isNotEmpty) {
      final firstDate = DateTime(DateTime.now().year,DateTime.now().month,01);
      final lastDate = DateTime.now();

      for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
        final currentDate = firstDate.add(Duration(days: i));
        final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

        final existingData = newData.firstWhere(
              (element) => element.date == formattedDate,
          orElse: () => CaloriesTrackingModel(
            id: 0,
            userId: widget.user.userId,
            date: formattedDate,
            totalCalories: 0,
            totalCaloriesIntake: 0,
            caloriesIntakeList: [],
            totalCaloriesBurned: 0,
            caloriesBurnedList: [],
          ),
        );

        expandedData.add(existingData);
      }
    }

    expandedData.sort((a,b)=>b.date.compareTo(a.date));
    return expandedData;
  }


  List<CaloriesTrackingModel> _graphData(List<CaloriesTrackingModel> data) {
    List<CaloriesTrackingModel> expandedData = [];

    final newData =caloriesInfoBox.values.toList();
    if (newData.isNotEmpty) {
      final firstDate = DateTime.now().subtract(Duration(days: 8));
      final lastDate = DateTime.now();

      for (int i = 0; i <= lastDate.difference(firstDate).inDays; i++) {
        final currentDate = firstDate.add(Duration(days: i));
        final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

        final existingData = newData.firstWhere(
              (element) => element.date == formattedDate,
          orElse: () => CaloriesTrackingModel(
            id: 0,
            userId: widget.user.userId,
            date: formattedDate,
            totalCalories: 0,
            totalCaloriesIntake: 0,
            caloriesIntakeList: [],
            totalCaloriesBurned: 0,
            caloriesBurnedList: [],
          ),
        );

        expandedData.add(existingData);
      }
    }

    // expandedData.sort((a,b)=>b.date.compareTo(a.date));
    return expandedData;
  }




  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      expandedData = _expandData(caloriesInfoBox.values.toList());
      graphData = _graphData(caloriesInfoBox.values.toList());
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    caloriesInfoBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        elevation: 3,
        backgroundColor: ColorManager.primary,
        title: Text('History'),
        titleTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: FaIcon(
            Icons.chevron_left,
            color: ColorManager.white,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              h20,
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    ),
                  color: ColorManager.white

                ),
          
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SfCartesianChart(
                      margin: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                      primaryXAxis: CategoryAxis(
                          isVisible: true,
                        interval: 1,
                        maximum: 7,
                        minimum: 1

                      ),
                      primaryYAxis: CategoryAxis(
                          isVisible: false,
                        minimum: 1
                      ),
                      palette: [
                        ColorManager.blue.withOpacity(0.7),
                        ColorManager.primary.withOpacity(0.7),
                        ColorManager.orange.withOpacity(0.7)
                      ],
                      series: [
                        SplineAreaSeries(
                            isVisible: isIntakeVisible,
                            borderColor: ColorManager.blue,
                            borderWidth: 2,
                            dataLabelSettings: DataLabelSettings(
                                isVisible: isIntakeLabelVisible,
                                color: ColorManager.blue,
                                labelIntersectAction: LabelIntersectAction.none
                            ),
                            dataSource: graphData,
                            xValueMapper: (CaloriesTrackingModel data, _) => DateFormat('yyyy-MM-dd').parse(data.date).day,
                            yValueMapper: (CaloriesTrackingModel data, _) => data.totalCaloriesIntake,
                            name: 'Total Calories Intake'
                        ),
                        SplineAreaSeries(
                            dataLabelSettings: DataLabelSettings(
                                isVisible: isTotalLabelVisible,
                                color: ColorManager.primary,
                                labelIntersectAction: LabelIntersectAction.none
                            ),
                            borderColor: ColorManager.primary,
                            borderWidth: 2,
                            isVisible: isTotalVisible,
                            dataSource: graphData,
                            // splineType: SplineType.cardinal,
                            xValueMapper: (CaloriesTrackingModel data, _) => DateFormat('yyyy-MM-dd').parse(data.date).day,
                            yValueMapper: (CaloriesTrackingModel data, _) => data.totalCalories,
                            name: 'Total Calories'
                        ),
                        SplineAreaSeries(
                            isVisible: isBurnedVisible,
                            dataLabelSettings: DataLabelSettings(
                                isVisible: isBurnedLabelVisible,
                                color: ColorManager.orange.withOpacity(0.7),
                                labelIntersectAction: LabelIntersectAction.none
                            ),
                            borderColor: ColorManager.orange,
                            borderWidth: 2,
                            dataSource: graphData,
                            xValueMapper: (CaloriesTrackingModel data, _) => DateFormat('yyyy-MM-dd').parse(data.date).day,
                            yValueMapper: (CaloriesTrackingModel data, _) => data.totalCaloriesBurned,
                            name: 'Total Calories Burned'
                        ),
                      ],
                    ),
                    h10,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        isTotalVisible = !isTotalVisible;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.chartArea,color: isTotalVisible? ColorManager.primary : ColorManager.black,size: 14,),
                                        w10,
                                        Text('Total Calories',style: getMediumStyle(color: isTotalVisible? ColorManager.primary : ColorManager.black,fontSize: 12),),
                                      ],
                                    )),
                                Checkbox(
                                    checkColor: ColorManager.primary,
                                    fillColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                    value: isTotalLabelVisible,
                                    onChanged: (value){
                                      setState(() {
                                        isTotalLabelVisible = !isTotalLabelVisible;
                                      });
                                    }
                                )
                              ],
                            ),
          
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        isIntakeVisible = !isIntakeVisible ;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.chartArea,color: isIntakeVisible? ColorManager.blue : ColorManager.black,size: 14,),
                                        w10,
                                        Text('Total Intake Calories',style: getMediumStyle(color: isIntakeVisible? ColorManager.blue : ColorManager.black,fontSize: 12),),
                                      ],
                                    )),
                                Checkbox(
          
                                    checkColor: ColorManager.blue,
                                    fillColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                    value: isIntakeLabelVisible,
                                    onChanged: (value){
                                      setState(() {
                                        isIntakeLabelVisible = !isIntakeLabelVisible;
                                      });
                                    }
                                )
                              ],
                            ),
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        isBurnedVisible = !isBurnedVisible ;
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        FaIcon(FontAwesomeIcons.chartArea,color:isBurnedVisible? ColorManager.orange.withOpacity(0.7) : ColorManager.black ,size: 14,),
                                        w10,
                                        Text('Total Burned Calories',style: getMediumStyle(color: isBurnedVisible? ColorManager.orange.withOpacity(0.7) : ColorManager.black,fontSize: 12),),
                                      ],
                                    )),
                                Checkbox(
                                    checkColor: ColorManager.orange.withOpacity(0.7),
                                    fillColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                    value: isBurnedLabelVisible,
                                    onChanged: (value){
                                      setState(() {
                                        isBurnedLabelVisible = !isBurnedLabelVisible;
                                      });
                                    }
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              h20,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(DateFormat('MMMM').format(DateTime.now()) ,style: getMediumStyle(color: ColorManager.black,fontSize: 20), ),
                  InkWell(
                      onTap: ()=>Get.to(()=>CaloriesAllRecords(user: widget.user,)),
                      child: Text('See all records >', style: getRegularStyle(color: ColorManager.black,fontSize: 16),))
                ],
              ),
              h20,
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: expandedData.length,
                itemBuilder: (context, index) {
                  final item = expandedData[index];

                  if (item.id == 0) {
                    // "add calories" item
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ListTile(
                        // tileColor: ColorManager.white,
                        onTap: ()=>Get.to(()=>PreviousCaloriesPage(data: item, user: widget.user,)),
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(
                            color: ColorManager.black.withOpacity(0.5)
                          )
                        ),
                        title: Text(item.date,style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        subtitle: Text('Add calories'),
                        trailing: FaIcon(Icons.add),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: ListTile(
                        onTap: ()=>Get.to(()=>PreviousCaloriesPage(data: item, user: widget.user,)),
                        tileColor: ColorManager.white,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                        trailing: FaIcon(Icons.chevron_right ),
                        title: Text(item.date,style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                        subtitle: Row(
                          children: [
                            Text('Total Calories:'),
                            w10,
                            Text('${item.totalCalories}',style: TextStyle(color: item.totalCalories  > widget.user.requiredCalories +200 ? ColorManager.red : item.totalCalories  < widget.user.requiredCalories -200 ? ColorManager.orange : ColorManager.primary  ),),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),

              h100,
            ],
          ),
        ),
      ),
    );
  }
}
