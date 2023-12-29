



import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/model/calories_model.dart';
import 'package:meroupachar/src/presentation/patient/calories/domain/services/activities_services.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

class AddCaloriesBurned extends  ConsumerStatefulWidget {
  final CaloriesTrackingModel data;
  final Box<CaloriesTrackingModel> caloriesBox;
  AddCaloriesBurned({required this.data,required this.caloriesBox});


  @override
  ConsumerState<AddCaloriesBurned> createState() => _AddCaloriesIntakeState();
}

class _AddCaloriesIntakeState extends ConsumerState<AddCaloriesBurned> {

  TextEditingController _nameController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _perHourController = TextEditingController();

  String? activities;

  bool isActivity = true;

  ActivitiesModel? activity;

  final _formKey = GlobalKey<FormState>();

  List<Map<String,dynamic>> activitiesList = [];

  void initState(){
    super.initState();

    // _getActivities();
  }

  void _addCaloriesBurned(CaloriesTrackingModel data) {
    final caloriesBox = Hive.box<CaloriesTrackingModel>('saved_userCalories_box');
    // Get the index of the reminder to update based on its 'reminderId' (you should replace 1002 with the actual 'reminderId' you want to update)
    final int indexToUpdate = caloriesBox.values.toList().indexWhere((element) => element.id == data.id);

    if (indexToUpdate != -1) {
      // If the reminder is found, update it
      caloriesBox.putAt(indexToUpdate, data);
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Box not found for update.');
    }
  }

  @override
  Widget build(BuildContext context) {

    // final demoList = [
    //   'sample 1',
    //   'sample 2',
    //   'sample 3',
    //   'sample 4',
    //   'sample 5',
    //   'sample 6',
    // ];


    final activityHive = Hive.box<ActivitiesModel>('saved_activities_box');
    final savedActivities = Hive.box<ActivitiesModel>('saved_activities_box').values.toList();

    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('Add Calories Burned'),
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                h20,
                TypeAheadField<String>(
                  builder: (context, controller, focusNode) {
                    return TextFormField(
                      controller: _nameController,
                      focusNode: focusNode,
                      validator: (value){
                        if(value!.trim().isEmpty){
                          return 'Activity is required';
                        }
                        if (value.contains(RegExp(r'^\d+$')))  {
                          return 'Invalid';
                        }

                        return null;
                      },
                      onChanged: (value) async {
                        final data = await ActivitiesService().getQueryActivities(query: value);
                        if(data.isEmpty){
                          setState(() {
                            isActivity = false;
                            _perHourController.clear();
                          });
                        }
                        if(data.isNotEmpty){
                          setState(() {
                            isActivity = true;
                            _perHourController.clear();
                          });
                        }

                        if(value.trim().isEmpty){
                          setState(() {
                            activity = null;
                            _perHourController.clear();
                          });
                        }

                      },
                      decoration: InputDecoration(
                          labelText: 'Activity',
                          labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                          hintText: 'Add a activity',
                          fillColor: ColorManager.dotGrey.withOpacity(0.8),
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.primary
                              )
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.primary
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.primary
                              )
                          )
                      ),
                    );
                  },
                  suggestionsCallback: (search) => ActivitiesService().getAllActivities(query: _nameController.text.isNotEmpty ? search : null),
                  itemBuilder: (context, e) {
                    return ListTile(
                      title: Text(e),
                    );
                  },
                  onSelected: (e) async {
                    setState(() {
                      _nameController.text = e;
                      activities = e;
                      isActivity = true;
                    });
                    if(_durationController.text.trim().isNotEmpty){
                      // Map<String,dynamic> param = {
                      //   'activity' : activities,
                      //   'weight' : 160,
                      //   'duration' : int.parse(_durationController.text)
                      // };

                      final data = await ActivitiesService().getActivitiesInfo(
                         activity: e,
                        duration: int.parse(_durationController.text),
                        weight: 160
                      );
                      setState(() {
                        activity = data;
                      });

                    }

                  },
                  emptyBuilder: (context) => SizedBox.shrink(),
                  controller: _nameController,
                  retainOnLoading: false,
                ),

                h20,
                if(!isActivity)
                  TextFormField(
                    controller: _perHourController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(value!.trim().isEmpty){
                        return 'Required';
                      }
                      if (!value.contains(RegExp(r'^\d+$')))  {
                        return 'Invalid';
                      }

                      return null;
                    },
                    onChanged: (value) async {
                      if(value.trim().isEmpty){
                        setState(() {
                          activity = null;
                        });
                      }
                      if(!isActivity && _durationController.text.trim().isNotEmpty){

                        int caloriesPerHour = int.parse(value);
                        int durationMinutes = int.parse(_durationController.text.trim());

                        ActivitiesModel newData = ActivitiesModel(
                            name: _nameController.text,
                            caloriesPerHour: int.parse(value),
                            durationMinutes: int.parse(_durationController.text.trim()),
                        );
                        setState(() {
                          activity = newData;
                        });
                      }
                    },
                    decoration: InputDecoration(
                        labelText: 'Calories burned per hour',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                        hintText: 'Add calories burned per hour',
                        fillColor: ColorManager.dotGrey.withOpacity(0.8),
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primary
                            )
                        )
                    ),
                  ),

                if(!isActivity)
                h20,
                TextFormField(
                  controller: _durationController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Required';
                    }
                    if (!value.contains(RegExp(r'^\d+$')))  {
                      return 'Invalid';
                    }

                    return null;
                  },
                  onChanged: (value) async {
                    if(value.trim().isEmpty){
                      setState(() {
                        activity = null;
                      });
                    }
                    if(activities != null){
                      // Map<String,dynamic> param = {
                      //   'activity' : activities,
                      //   'weight' : 160,
                      //   'duration' : int.parse(value)
                      // };

                      print('new activity : $activities');

                      final tryData = savedActivities.firstWhereOrNull((element) => element.name == activities!);

                      if(tryData == null){
                        final data = await ActivitiesService().getActivitiesInfo(
                            activity: activities!,
                            duration: int.parse(value.trim()),
                            weight: 160
                        );
                        setState(() {
                          activity = data;
                        });
                      }
                      else{
                        setState(() {
                          activity = tryData;
                        });
                      }



                    }
                    if(!isActivity && _perHourController.text.isNotEmpty){

                      int caloriesPerHour = int.parse(_perHourController.text.trim());
                      int durationMinutes = int.parse(value);

                      ActivitiesModel newData = ActivitiesModel(
                          name: _nameController.text,
                          caloriesPerHour: int.parse(_perHourController.text.trim()),
                          durationMinutes: int.parse(value),
                      );
                      setState(() {
                        activity = newData;
                      });
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Duration - in min',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      hintText: 'Add duration',
                      fillColor: ColorManager.dotGrey.withOpacity(0.8),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      )
                  ),
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Total Calories Burned :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                    w10,
                    if(activity != null && _durationController.text.trim().isNotEmpty)
                    Text('${(((activity!.caloriesPerHour)/60)*int.parse(_durationController.text.trim())).round()}',style: getMediumStyle(color: ColorManager.black,fontSize: 20),)
                  ],
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

                        int totalBurned = (((activity!.caloriesPerHour)/60)* int.parse(_durationController.text.trim())).round();

                        // if(selectedGoalId == -1){
                        //   scaffoldMessage.showSnackBar(
                        //     SnackbarUtil.showFailureSnackbar(
                        //         message: 'Please select a activity level',
                        //         duration: const Duration(seconds: 2)
                        //     ),
                        //   );

                        if(!isActivity){
                          ActivitiesModel newActivity = ActivitiesModel(
                              name: _nameController.text.trim(),
                              caloriesPerHour: int.parse(_perHourController.text.trim()),
                              durationMinutes: int.parse(_durationController.text.trim())
                          );
                          await activityHive.add(newActivity);
                          }

                        CaloriesBurnedModel burnedModel = CaloriesBurnedModel(
                            activityName: _nameController.text.trim(),
                            caloriesPerHour: activity!.caloriesPerHour,
                            duration: int.parse(_durationController.text.trim()),
                            caloriesBurned: ((activity!.caloriesPerHour/60)* int.parse(_durationController.text.trim())).round()
                        );
                        widget.data.caloriesBurnedList.add(burnedModel);

                        CaloriesTrackingModel newModel = CaloriesTrackingModel(
                            id: widget.data.id,
                            userId: widget.data.userId,
                            date: widget.data.date,
                            totalCalories: (widget.data.totalCalories - totalBurned).round(),
                            totalCaloriesIntake: widget.data.totalCalories,
                            caloriesIntakeList: widget.data.caloriesIntakeList,
                            totalCaloriesBurned: (widget.data.totalCaloriesBurned + totalBurned).round(),
                            caloriesBurnedList: widget.data.caloriesBurnedList
                        );

                        _addCaloriesBurned(newModel);

                      }


                    },
                    child: Text('Add',style: getRegularStyle(color: ColorManager.white,fontSize: 16),))

              ],
            ),
          ),
        ),
      ),
    );
  }
}
