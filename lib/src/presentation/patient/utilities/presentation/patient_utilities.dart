import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:meroupachar/src/presentation/patient/calories/presentation/calories_userInfo.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../../widgets/bmi.dart';
import '../../../widgets/bmr.dart';
import '../../../widgets/edd.dart';
import '../../calories/domain/model/calories_model.dart';
import '../../calories/presentation/calories_detail.dart';

class PatientUtilities extends StatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final User user;
  PatientUtilities(this.isWideScreen,this.isNarrowScreen,this.user);

  @override
  State<PatientUtilities> createState() => _PatientUtilitiesState();
}

class _PatientUtilitiesState extends State<PatientUtilities> {


  late CaloriesTrackingModel todayTracking;
  late Box<CaloriesTrackingModel> caloriesInfoBox;
  late ValueListenable<Box<CaloriesTrackingModel>> caloriesInfoBoxListenable;
  late Box<UserInfoCalories> userInfoBox;
  late ValueListenable<Box<UserInfoCalories>> userInfoBoxListenable;

  @override
  void initState() {
    super.initState();

    todayTracking = CaloriesTrackingModel(
      id: Random().nextInt(9999),
      userId: widget.user.username!,
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      totalCalories: 0,
      totalCaloriesIntake: 0,
      caloriesIntakeList: [],
      totalCaloriesBurned: 0,
      caloriesBurnedList: [],
    );

    userInfoBox = Hive.box<UserInfoCalories>('saved_userInfo_box');
    userInfoBoxListenable = userInfoBox.listenable();
    userInfoBoxListenable.addListener(_onHiveBoxChanged);

    caloriesInfoBox = Hive.box<CaloriesTrackingModel>('saved_userCalories_box');
    caloriesInfoBoxListenable = caloriesInfoBox.listenable();
    caloriesInfoBoxListenable.addListener(_onHiveBoxChanged);


    _createCurrentTracker();
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



  void _createCurrentTracker() async {
    final userInfo = userInfoBox.values.toList();
    final isUser = userInfo.firstWhereOrNull((element) => element.userId == widget.user.username);

    if (isUser != null) {
      final caloriesTrackList = caloriesInfoBox.values.toList();
      final isCaloriesTracked =
      caloriesTrackList.firstWhereOrNull((element) => element.date == DateFormat('yyyy-MM-dd').format(DateTime.now()));

      final previousCaloriesTracked =
      caloriesTrackList.firstWhereOrNull((element) => element.date == DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 1))));

      if(previousCaloriesTracked?.totalCalories == 0){
        final int indexToUpdate = caloriesInfoBox.values.toList().indexWhere((element) => element.id == previousCaloriesTracked?.id);
        caloriesInfoBox.deleteAt(indexToUpdate);
      }

      if (isCaloriesTracked != null) {
        setState(() {
          todayTracking = isCaloriesTracked;
        });
        print('existed');
      }
      else{
          caloriesInfoBox.add(todayTracking);
      }


    }
  }

    
    


  @override
  Widget build(BuildContext context) {

    final userInfo = userInfoBox.values.toList();
    final isUser = userInfo.firstWhereOrNull((element) => element.userId == widget.user.username);

    if (isUser != null) {
      final caloriesTrackList = caloriesInfoBox.values.toList();
      final isCaloriesTracked =
      caloriesTrackList.firstWhereOrNull((element) => element.date == DateFormat('yyyy-MM-dd').format(DateTime.now()));

      if (isCaloriesTracked != null) {
        setState(() {
          todayTracking = isCaloriesTracked;
        });
        print('existed');
      }
      else{
        caloriesInfoBox.add(todayTracking);
      }
    }



    return Scaffold(
      backgroundColor: ColorManager.dotGrey.withOpacity(0.01),
      appBar: AppBar(
        backgroundColor: ColorManager.primaryDark.withOpacity(0.9),
        elevation: 1,
        title: Text('Utilities',style: getMediumStyle(color: ColorManager.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            h20,
            _patientStat(context),
            h20,

            _caloriesBody(),
            _buildCalculatorBody()

          ],
        ),
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
                  icon: 'bmi_final',
                  name: 'BMI',
                  onTap: ()=>Get.to(()=>BMI())
              ),
              _buildCalculators(
                  icon: 'bmr3',
                  name: 'BMR',
                  onTap: ()=>Get.to(()=>BMR())
              ),
              _buildCalculators(
                  icon: 'duedate',
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
                          FaIcon(CupertinoIcons.graph_circle_fill,color: ColorManager.primary.withOpacity(0.5),size: 20.sp,),
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

  Widget _caloriesBody() {
    final userInfo = userInfoBox.values.toList();
    final isUser = userInfo.firstWhereOrNull((element) => element.userId == widget.user.username);

    if (isUser == null) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorManager.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(

            onTap: () => Get.to(() => CaloriesUserInfo()),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorManager.white,
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.8),
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Start Calories Tracking', style: getMediumStyle(color: ColorManager.black, fontSize: 16)),
                      FaIcon(Icons.chevron_right, color: ColorManager.black),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 0,
          color: ColorManager.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: InkWell(
            onTap: () => Get.to(() => CaloriesPage(data: todayTracking, user: isUser)),

            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorManager.white,
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.8),
                  width: 0.5,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
              child: ValueListenableBuilder<Box<CaloriesTrackingModel>>(
                valueListenable: caloriesInfoBoxListenable,
                builder: (context, box, _) {
                  todayTracking = box.values.toList().firstWhereOrNull((element) => element.date == DateFormat('yyyy-MM-dd').format(DateTime.now())) ?? todayTracking;

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calories', style: getMediumStyle(color: ColorManager.black, fontSize: 16)),
                          Text(DateFormat('yyyy-MM-dd').format(DateTime.now()), style: getRegularStyle(color: ColorManager.black, fontSize: 12)),
                        ],
                      ),
                      Text('Total Calories: ${todayTracking.totalCalories}', style: getRegularStyle(color: ColorManager.black, fontSize: 14)),
                      h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Calories Intake: ${todayTracking.totalCaloriesIntake}', style: getRegularStyle(color: ColorManager.primary, fontSize: 12)),
                          Text('Calories Burned: ${todayTracking.totalCaloriesBurned}', style: getRegularStyle(color: ColorManager.orange.withOpacity(0.8), fontSize: 12)),
                        ],
                      ),
                      h10,
                      LinearProgressBar(
                        currentStep: todayTracking.totalCalories,
                        backgroundColor: ColorManager.dotGrey.withOpacity(0.5),
                        maxSteps: isUser.requiredCalories,
                        progressColor: ColorManager.primary,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }


}

