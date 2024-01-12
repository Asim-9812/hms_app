



import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';
import '../domain/data/calories_datas.dart';

class CaloriesUserInfo extends StatefulWidget {
  const CaloriesUserInfo({super.key});

  @override
  State<CaloriesUserInfo> createState() => _CaloriesUserInfoState();
}

class _CaloriesUserInfoState extends State<CaloriesUserInfo> {


  TextEditingController _weightController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _ftController = TextEditingController();
  TextEditingController _inchController = TextEditingController();
  // TextEditingController _heightController = TextEditingController();

  String selectedActivity = 'None';
  String? selectedGoal;
  String? gender;
  int genderId = -1;
  int selectedActivityId = 0;
  int selectedGoalId = -1;
  double _value = 0.0;


  bool disableValidate = true;


  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {

    final userInfoBox = Hive.box<UserInfoCalories>('saved_userInfo_box');

    final userBox = Hive.box<User>('session').values.toList()[0];

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('Add Your Information'),
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
          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add your age :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                      w10,
                      Expanded(
                        child: TextFormField(
                          controller: _ageController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value!.trim().isEmpty){
                              return 'Required';
                            }
                            if (!value.contains(RegExp(r'^\d+$')))  {
                              return 'Invalid';
                            }
                            if(int.parse(value) < 1 || int.parse(value) > 100){
                              return 'Invalid';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: ColorManager.dotGrey.withOpacity(0.8),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Add your weight (in KG) :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                      w10,
                      Expanded(
                        child: TextFormField(
                          controller: _weightController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value!.trim().isEmpty){
                              return 'Required';
                            }
                            if (!value.contains(RegExp(r'^\d+$')))  {
                              return 'Invalid';
                            }
                            if(int.parse(value) < 10 || int.parse(value) > 300){
                              return 'Invalid';
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                            fillColor: ColorManager.dotGrey.withOpacity(0.8),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Add your height :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                      w10,
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: disableValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                              return 'Invalid';
                            }
                            if (double.parse(value) > 8.0) {
                              return 'Invalid';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _value = (double.parse(_ftController.text) * 30.48) +
                                  ((double.parse(_inchController.text.isNotEmpty ? _inchController.text : '0')) * 2.54);
                            });
                          },
                          controller: _ftController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                          style: getMediumStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'ft',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1), // Change the limit as needed
                          ],
                        ),
                      ),
                      w10,
                      Expanded(
                        child: TextFormField(
                          autovalidateMode: disableValidate
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (!RegExp(r'^\d+(\.\d+)?$').hasMatch(value)) {
                              return 'Invalid';
                            }
                            if (double.parse(value) > 11.0) {
                              return 'Invalid';
                            }
                            if (_ftController.text.isNotEmpty) {
                              if (double.parse(_ftController.text) == 8.0 &&
                                  double.parse(_inchController.text) > 0) {
                                return 'Invalid';
                              }
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              _value = (double.parse(_ftController.text) * 30.48) +
                                  (double.parse(_inchController.text) * 2.54);
                            });
                          },
                          controller: _inchController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                          style: getMediumStyle(
                            color: ColorManager.black,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorManager.dotGrey.withOpacity(0.2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'in',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(2), // Change the limit as needed
                          ],
                        ),
                      )

                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Select Gender :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                      w20,
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              genderId = 0;
                              gender = 'Male';
                            });
                            print('tapped');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: genderId == 0 ? ColorManager.primary : ColorManager.black.withOpacity(0.5)
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: genderId == 0?ColorManager.primary.withOpacity(0.5): null
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child:  Text('Male',style: getMediumStyle(color: ColorManager.black , fontSize: 12 ),),
                            ),
                          ),
                        ),
                      ),
                      w10,
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              genderId = 1;
                              gender = 'Female';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: genderId == 1 ? ColorManager.primary : ColorManager.black.withOpacity(0.5)
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: genderId==1 ? ColorManager.primary.withOpacity(0.5) : null
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            child: Center(
                              child:  Text('Female',style: getMediumStyle(color: ColorManager.black , fontSize: 12 ),),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  h20,
                  DropdownButtonFormField<String>(
                    isDense: true,
                    validator: (value){

                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    value: selectedActivity,

                    decoration: InputDecoration(
                      isDense: true,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      labelText: 'Activity Level',
                      labelStyle: getRegularStyle(color: ColorManager.primary),
                      // filled: true,
                      // fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    items: activityLevelList
                        .map(
                          (ActivityTypeModel item) => DropdownMenuItem<String>(
                        value: item.activityName,
                        child: Text(
                          item.activityName,
                          style: getRegularStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedActivity = value!;
                        selectedActivityId = activityLevelList.firstWhere((element) => element.activityName == value).activityId;

                      });
                    },
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      goalList.length,
                          (index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedGoalId = index;
                            selectedGoal = goalList[index].goalName;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedGoalId == index
                                ? ColorManager.primary.withOpacity(0.2)
                                : ColorManager.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: selectedGoalId == index
                                  ? ColorManager.primary
                                  : ColorManager.black.withOpacity(0.8),
                              width: selectedGoalId == index ? 1 : 0.5,
                            ),
                          ),
                          height: 100,
                          width: 100,

                          child: Center(
                            child: Text('${goalList[index].goalName}\nWeight',style: getMediumStyle(color: ColorManager.black,fontSize: 20),textAlign: TextAlign.center,),
                          ),
                        ),
                      ),
                    ),
                  ),
                  h20,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.primary,
                        elevation: 0,
                        fixedSize: Size.fromWidth(200.w)
                      ),
                      onPressed: () async {
                        final scaffoldMessage = ScaffoldMessenger.of(context);
                        if(_formKey.currentState!.validate()){
                          if(genderId == -1){
                            scaffoldMessage.showSnackBar(
                              SnackbarUtil.showFailureSnackbar(
                                  message: 'Please select a gender',
                                  duration: const Duration(seconds: 2)
                              ),
                            );
                          }
                          else if(selectedGoalId == -1){
                            scaffoldMessage.showSnackBar(
                              SnackbarUtil.showFailureSnackbar(
                                  message: 'Please select a activity level',
                                  duration: const Duration(seconds: 2)
                              ),
                            );
                          }
                          else{

                            int caloriesNeeded = 0;
                            int weight = int.parse(_weightController.text.trim());
                            int height = _value.round();
                            int age = int.parse(_ageController.text.trim());
                            double activityFactor =
                                  selectedActivityId == 0 ? 1.2
                                : selectedActivityId == 1 ? 1.375
                                : selectedActivityId == 2? 1.55
                                : selectedActivityId == 3 ? 1.725
                                : 1.9
                            ;
                            double weightFactor =
                                selectedGoalId == 0 ? 0.9
                                    : selectedGoalId == 1 ? 1.0
                                    : 1.1
                            ;
                            if(genderId == 0){
                              /// for men...
                             final calculatedBMR = 88.362+(13.397*weight)+(4.799*height)-(5.677*age);

                             final calculatedCalories = calculatedBMR * activityFactor * weightFactor;

                             setState(() {
                               caloriesNeeded = calculatedCalories.round();
                             });
                            }
                            else{
                              /// for women...
                              final calculatedBMR = 447.593+(9.247*weight)+(3.098*height)-(4.330*age);

                              final calculatedCalories = calculatedBMR * activityFactor * weightFactor;

                              setState(() {
                                caloriesNeeded = calculatedCalories.round();
                              });
                            }


                            UserInfoCalories user = UserInfoCalories(
                                id: Random().nextInt(9999),
                                userId: userBox.username!,
                                age: age,
                                height: _value.round(),
                                weight: (int.parse(_weightController.text.trim()) * 2.2).round(),
                                activityIntensity: ActivityTypeModel(activityId: selectedActivityId, activityName: selectedActivity),
                                goal: GoalTypeModel(goalId: selectedGoalId, goalName: selectedGoal!),
                              gender: gender!,
                              requiredCalories: caloriesNeeded
                            );
                            await userInfoBox.add(user);

                            Navigator.pop(context);

                          }
                        }
                      },
                      child: Text('Save',style: getRegularStyle(color: ColorManager.white,fontSize: 16),))

                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
