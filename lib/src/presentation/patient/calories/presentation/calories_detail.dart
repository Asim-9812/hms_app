




import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';
import 'package:meroupachar/src/presentation/patient/calories/presentation/add_calories_burned.dart';
import 'package:meroupachar/src/presentation/patient/calories/presentation/add_calories_intake.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import 'calories_history.dart';
import 'calories_update_userInfo.dart';

class CaloriesPage extends StatefulWidget {
  final CaloriesTrackingModel data;
  final UserInfoCalories user;
  CaloriesPage({required this.data,required this.user});

  @override
  State<CaloriesPage> createState() => _CaloriesPageState();
}

class _CaloriesPageState extends State<CaloriesPage> {


  late Box<CaloriesTrackingModel> caloriesInfoBox;
  late ValueListenable<Box<CaloriesTrackingModel>> caloriesInfoBoxListenable;



  late Box<UserInfoCalories> userInfoBox;
  late ValueListenable<Box<UserInfoCalories>> userInfoBoxListenable;



  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    caloriesInfoBox = Hive.box<CaloriesTrackingModel>('saved_userCalories_box');

    // Create a ValueListenable for the box
    caloriesInfoBoxListenable = caloriesInfoBox.listenable();

    // Add a listener to update the UI when the box changes
    caloriesInfoBoxListenable.addListener(_onHiveBoxChanged);


    userInfoBox = Hive.box<UserInfoCalories>('saved_userInfo_box');
    userInfoBoxListenable = userInfoBox.listenable();
    userInfoBoxListenable.addListener(_onHiveBoxChanged);


  }



  void _deleteFood(CaloriesTrackingModel data, CaloriesIntakeModel food){

    final int indexToUpdate = caloriesInfoBox.values.toList().indexWhere((element) => element.id == data.id);


    data.caloriesIntakeList.removeWhere((element) => element.food == food.food && element.caloriesIntake == food.caloriesIntake);

    CaloriesTrackingModel newData = CaloriesTrackingModel(
        id: data.id,
        userId: data.userId,
        date: data.date,
        totalCalories: data.totalCalories - food.caloriesIntake,
        totalCaloriesIntake: data.totalCaloriesIntake - food.caloriesIntake,
        caloriesIntakeList: data.caloriesIntakeList,
        totalCaloriesBurned: data.totalCaloriesBurned,
        caloriesBurnedList: data.caloriesBurnedList
    );

    if (indexToUpdate != -1) {
      // If the reminder is found, update it
      caloriesInfoBox.putAt(indexToUpdate, newData);
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Box not found for update.');
    }





  }


  void _deleteActivity(CaloriesTrackingModel data, CaloriesBurnedModel activity){

    final int indexToUpdate = caloriesInfoBox.values.toList().indexWhere((element) => element.id == data.id);


    data.caloriesBurnedList.removeWhere((element) => element.activityName == activity.activityName && element.caloriesBurned == activity.caloriesBurned);

    CaloriesTrackingModel newData = CaloriesTrackingModel(
        id: data.id,
        userId: data.userId,
        date: data.date,
        totalCalories: data.totalCalories + activity.caloriesBurned,
        totalCaloriesIntake: data.totalCaloriesIntake,
        caloriesIntakeList: data.caloriesIntakeList,
        totalCaloriesBurned: data.totalCaloriesBurned-activity.caloriesBurned,
        caloriesBurnedList: data.caloriesBurnedList
    );

    if (indexToUpdate != -1) {
      // If the reminder is found, update it
      caloriesInfoBox.putAt(indexToUpdate, newData);
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Box not found for update.');
    }





  }


  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    caloriesInfoBoxListenable.removeListener(_onHiveBoxChanged);

    userInfoBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }







  @override
  Widget build(BuildContext context) {

    final String disclaimer ='This is a tool designed to assist users in monitoring their calorie intake and managing their diet. While we strive to provide accurate and up-to-date information, we cannot guarantee the precision, completeness, or reliability of the data presented by the tracker. It is important to note that the tracker is not a substitute for professional medical advice, diagnosis, or treatment. Users should consult with a qualified healthcare professional before making any dietary or lifestyle changes based on information obtained from the App. Nutritional needs vary among individuals, and the App\'s general guidelines may not be suitable for everyone. Users are responsible for assessing their unique nutritional requirements and adjusting their diet accordingly. We are committed to data security, but users should take precautions to protect their personal information';



    final data = Hive.box<CaloriesTrackingModel>('saved_userCalories_box').values.where((element) => element.userId == widget.user.userId).toList();
    data.sort((a,b)=>b.date.compareTo(a.date));
    final currentData = data.firstWhere((element) => element.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) ;

    final currentUser = userInfoBox.values.toList().firstWhere((element) => element.userId == widget.user.userId);

    final foodList = Hive.box<AddFoodModel>('food_box').values.toList();

    List<Map<String, dynamic>> caloriesChart = [
      {'category': 'Calories Burned', 'value': currentData.totalCaloriesBurned},
      {'category': 'Calories Intake', 'value': currentData.totalCaloriesIntake},
      {'category': 'Total Calories', 'value': currentData.totalCalories},
    ];



    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        elevation: 3,
        backgroundColor: ColorManager.primary,
        title: Text('Calories'),
        titleTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: FaIcon(
            Icons.chevron_left,
            color: ColorManager.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: ()=>Get.to(()=>CaloriesUpdateUserInfo(user: currentUser,)),
              icon: FaIcon(CupertinoIcons.info,color: ColorManager.white,))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              h20,
              Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                color: ColorManager.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: InkWell(
                  // onTap: ()=>Get.to(()=>CaloriesUserInfo()),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.white,
          
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${currentData.date}',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Daily Calories Requirement : ${currentUser.requiredCalories}',style: getMediumStyle(color: ColorManager.black,fontSize: 14),),
                                w10,
                                InkWell(
                                    onTap: ()async{
                                      await showDialog(context: context, builder: (context){
                                        return AlertDialog(
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Disclaimer',style: getMediumStyle(color: ColorManager.black),),
                                              h10,
                                              Text('$disclaimer',style: getRegularStyle(color: ColorManager.black,fontSize: 14),maxLines: null,textAlign: TextAlign.justify,),

                                            ],
                                          ),
                                        );
                                      });
                                    },
                                    child: FaIcon(Icons.info_rounded,color: ColorManager.primary,))
                              ],
                            ),
                          ],
                        ),

                        SfCircularChart(

                          palette: [
                            ColorManager.yellowFellow,
                            ColorManager.blue,
                            ColorManager.primary,
                          ],
                          series: <CircularSeries>[
                            RadialBarSeries(
                              maximumValue: currentUser.requiredCalories.toDouble(),
                              xValueMapper: (data, _) => data['category'],
                              yValueMapper: (data, _) =>data['value'],
                              dataLabelMapper: (data, _) => data['value'].toString(),
                              dataSource: caloriesChart
                            ),
                          ],
                        ),

                        Text('Total Calories : ${currentData.totalCalories}',style: getMediumStyle(color: ColorManager.primary,fontSize: 12),),
                        Text('Total Calories Intake : ${currentData.totalCaloriesIntake}',style: getMediumStyle(color: ColorManager.blue,fontSize: 12),),
                        Text('Total Calories Burned : ${currentData.totalCaloriesBurned}',style: getMediumStyle(color: ColorManager.orange,fontSize: 12),),

                      ],
                    ),
          
                  ),
                ),
              ),
              h20,
              Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                color: ColorManager.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: InkWell(
                  // onTap: ()=>Get.to(()=>CaloriesUserInfo()),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.white,
          
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Calories Intake: ${currentData.totalCaloriesIntake}',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                            InkWell(
                                onTap: ()=>Get.to(()=>AddCaloriesIntake(data: currentData,caloriesBox:caloriesInfoBox)),
                                child: FaIcon(Icons.add,color: ColorManager.primary,))
                          ],
                        ),
          
                        Row(
                          children: [
                            Expanded(
                              child: DataTable(
                                        
                                border: TableBorder.symmetric(
                                    outside: BorderSide.none,
                                  // inside: BorderSide(
                                  //   color: ColorManager.black.withOpacity(0.5)
                                  // )
                                ),
                                headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                headingTextStyle: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                columnSpacing: MediaQuery.of(context).size.width/2.5,
                                columns: [
                                  DataColumn(label: Text('Food')),
                                  DataColumn(label: Text('Calories')),
                                ],
                                rows: currentData.caloriesIntakeList.map((e) {
                                  return DataRow(
                                        
                                      cells: [
                                        DataCell(Text('${e.food}')),
                                        DataCell(Text('${e.caloriesIntake}')),
                                      ],
                                    onLongPress: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Do you want to delete the item?',style: getRegularStyle(color: ColorManager.black),),
                                                    h10,
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            shape: ContinuousRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),

                                                            ),
                                                            backgroundColor: ColorManager.primary
                                                        ),
                                                        onPressed: ()=>_deleteFood(currentData , e),
                                                        child: Text('Yes',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        );
                                    }
                                  );
                                }).toList(),
                                        
                                dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                              ),
                            ),
                          ],
                        )
          
                      ],
                    ),
          
                  ),
                ),
              ),
              h20,
              Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                color: ColorManager.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: InkWell(
                  // onTap: ()=>Get.to(()=>CaloriesUserInfo()),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.white,
          
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Calories Burned: ${currentData.totalCaloriesBurned}',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                            InkWell(
                                onTap: ()=>Get.to(()=>AddCaloriesBurned(data: currentData,caloriesBox: caloriesInfoBox,)),
                                child: FaIcon(Icons.add,color: ColorManager.primary,))
                          ],
                        ),
          
                        Row(
                          children: [
                            Expanded(
                              child: DataTable(

                                border: TableBorder.symmetric(
                                    outside: BorderSide.none,
                                  // inside: BorderSide(
                                  //   color: ColorManager.black.withOpacity(0.5)
                                  // )
                                ),
                                headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                headingTextStyle: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                columnSpacing: MediaQuery.of(context).size.width/3,
                                columns: [
                                  DataColumn(label: Text('Activity')),
                                  DataColumn(label: Text('Calories')),
                                ],
                                rows: currentData.caloriesBurnedList.map((e) {
                                  return DataRow(

                                      cells: [
                                        DataCell(Text(e.activityName.split(' ').length >2 ? '${e.activityName.split(' ')[0]} ${e.activityName.split(' ')[1]}':'${e.activityName}')),
                                        DataCell(Text('${e.caloriesBurned}')),
                                      ],
                                      onLongPress: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (context){
                                              return AlertDialog(
                                                content: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Do you want to delete the item?',style: getRegularStyle(color: ColorManager.black),),
                                                    h10,
                                                    ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        shape: ContinuousRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10),

                                                        ),
                                                        backgroundColor: ColorManager.primary
                                                      ),
                                                        onPressed: ()=>_deleteActivity(currentData , e),
                                                        child: Text('Yes',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)
                                                    )
                                                  ],
                                                ),
                                              );
                                            }
                                        );
                                      }
                                  );
                                }).toList(),

                                dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                              ),
                            ),
                          ],
                        )
          
                      ],
                    ),
          
                  ),
                ),
              ),
              h20,
              Card(
                margin: EdgeInsets.zero,
                elevation: 5,
                color: ColorManager.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                ),
                child: InkWell(
                  onTap: ()=>Get.to(()=>CaloriesHistory(data: data,user: currentUser,)),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ColorManager.white,
          
                    ),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('History',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
          
                        Row(
                          children: [
                            Expanded(
                              child: DataTable(

                                border: TableBorder.symmetric(
                                    outside: BorderSide.none,
                                  // inside: BorderSide(
                                  //   color: ColorManager.black.withOpacity(0.5)
                                  // )
                                ),
                                headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.white),
                                headingTextStyle: getMediumStyle(color: ColorManager.black,fontSize: 16),
                                // columnSpacing: MediaQuery.of(context).size.width/2.5,
                                columns: [
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Calories')),
                                ],
                                rows: data.take(5).map((e) {
                                  return DataRow(

                                      cells: [
                                        DataCell(Text('${e.date}')),
                                        DataCell(Text('${e.totalCalories}')),
                                      ]
                                  );
                                }).toList(),

                                dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
          
                  ),
                ),
              ),


              h100,
              h100,
            ],
          ),
        ),
      ),
    );
  }
}
