import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../domain/model/calories_model.dart';

class AddCaloriesIntake extends StatefulWidget {
  final CaloriesTrackingModel data;
  final Box<CaloriesTrackingModel> caloriesBox;
  AddCaloriesIntake({required this.data,required this.caloriesBox});

  @override
  State<AddCaloriesIntake> createState() => _AddCaloriesIntakeState();
}

class _AddCaloriesIntakeState extends State<AddCaloriesIntake> {
  TextEditingController nameController = TextEditingController();
  TextEditingController servingController = TextEditingController();
  TextEditingController cpsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  String query = '';
  double totalCalories = 0;

  String? searchQuery ;


  void _addCaloriesIntake(CaloriesTrackingModel data) {
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

  _launchURL(String url) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    try {
      final search = 'https://www.google.com/search?q=$url+calories+per+serving' ;
      await launchUrlString(search,mode: LaunchMode.externalApplication);
    } catch (e) {
      // If launching with 'https://' fails, try with 'http://'
      if (!url.startsWith('http://')) {
        url = 'http://$url';
        await launchUrlString(url,mode: LaunchMode.externalApplication);
      } else {
        scaffoldMessage.showSnackBar(
            SnackbarUtil.showFailureSnackbar(
                message: 'Invalid Url',
                duration: const Duration(milliseconds: 1200)
            )
        );
        print('Error launching URL: $e');
      }
    }
  }



  @override
  Widget build(BuildContext context) {

    final foodList = Hive.box<AddFoodModel>('food_box').values.toList();

    // List<AddFoodModel> newList = [
    //   AddFoodModel('food', 100),
    //   AddFoodModel('food1', 100),
    //   AddFoodModel('food2', 100),
    //   AddFoodModel('food3', 100),
    // ];



    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          elevation: 3,
          backgroundColor: ColorManager.primary,
          title: Text('Add Calories Intake'),
          titleTextStyle: getMediumStyle(color: ColorManager.white, fontSize: 20),
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  h20,
                  Row(
                    children: [
                      Expanded(
                        child: TypeAheadField<AddFoodModel>(
                          builder: (context, controller, focusNode) {
                            return TextFormField(
                              controller: nameController,
                              focusNode: focusNode,
                              validator: (value){
                                if(value!.trim().isEmpty){
                                  return 'Food name is required';
                                }
                                if (value.contains(RegExp(r'^\d+$')))  {
                                  return 'Invalid';
                                }
                        
                                return null;
                              },
                              decoration: InputDecoration(
                                  labelText: 'Food',
                                  labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                                  hintText: 'Add a food name',
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
                              onChanged: (value){
                                if(value.trim().isEmpty){
                                  setState(() {
                                    searchQuery = null;
                                  });
                                }
                                else{
                                  setState(() {
                                    searchQuery = value;
                                  });
                                }

                              },
                            );
                          },
                          suggestionsCallback: (search) {
                            return foodList
                                .where((food) =>
                                food.food.toLowerCase().contains(search.toLowerCase()))
                                .map((e) => e)
                                .toList();
                          },
                          itemBuilder: (context, food) {
                            return ListTile(
                              title: Text(food.food),
                              subtitle: Text('${food.calories.round().toString()} calories per serving'),
                            );
                          },
                          onSelected: (food) {
                            setState(() {
                              nameController.text = food.food;
                              cpsController.text = food.calories.round().toString();
                            });
                          },
                          emptyBuilder: (context) => SizedBox.shrink(),
                          controller: nameController,
                          retainOnLoading: false,
                        ),
                      ),
                      w10,
                      IconButton(
                        style: IconButton.styleFrom(
                          shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color:searchQuery == null?ColorManager.black: ColorManager.primary
                            )
                          ),
                          backgroundColor: searchQuery == null? null :ColorManager.primary
                        ),
                          onPressed: (){
                            _launchURL(searchQuery!);
                          },
                          icon: FaIcon(Icons.search,color:searchQuery == null? ColorManager.black: ColorManager.white,)
                      )
                    ],
                  ),
                  h20,
                  TextFormField(
                    controller: cpsController,
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
                    decoration: InputDecoration(
                        labelText: 'Calories per serving',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                        hintText: 'Add calories per serving',
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
                    onChanged: (value){
                      if(cpsController.text.isNotEmpty && servingController.text.isNotEmpty){
                        setState(() {
                          totalCalories = double.parse(cpsController.text) * double.parse(servingController.text);
                        });
                      }
                    },
                  ),
                  h20,
                  TextFormField(
                    controller: servingController,
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
                    decoration: InputDecoration(
                        labelText: 'Serving',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                        hintText: 'Add serving',
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
                    onChanged: (value){
                      if(cpsController.text.isNotEmpty && servingController.text.isNotEmpty){
                        setState(() {
                          totalCalories = double.parse(cpsController.text) * double.parse(servingController.text);
                        });
                      }
                    },
                  ),
                  h20,


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Total Calories :',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
                      w10,
                      Text('${totalCalories.round()}',style: getMediumStyle(color: ColorManager.black,fontSize: 20),)
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

                        try {
                          // Access the already opened box directly
                          final foodHive = Hive.box<AddFoodModel>('food_box');
                          final isFood = foodList.firstWhereOrNull((element) => element.food == nameController.text.trim() && element.calories == double.parse(cpsController.text));




                          if (_formKey.currentState!.validate()) {

                            if(isFood == null){
                              AddFoodModel addFoodModel = AddFoodModel(
                                nameController.text.trim(),
                                double.parse(cpsController.text),
                              );

                              await foodHive.add(addFoodModel);


                            }



                            CaloriesIntakeModel intakeModel = CaloriesIntakeModel(
                                food: nameController.text.trim(),
                                caloriesPerServing: int.parse(cpsController.text),
                                serving: int.parse(servingController.text),
                                caloriesIntake: int.parse(servingController.text) * int.parse(cpsController.text)
                            );



                           widget.data.caloriesIntakeList.add(intakeModel);

                            CaloriesTrackingModel newModel = CaloriesTrackingModel(
                                id: widget.data.id,
                                userId: widget.data.userId,
                                date: widget.data.date,
                                totalCalories: (widget.data.totalCalories + totalCalories).round(),
                                totalCaloriesIntake: (widget.data.totalCaloriesIntake + totalCalories).round(),
                                caloriesIntakeList: widget.data.caloriesIntakeList,
                                totalCaloriesBurned: widget.data.totalCaloriesBurned,
                                caloriesBurnedList: widget.data.caloriesBurnedList
                            );

                            _addCaloriesIntake(newModel);




                          }
                        } catch (e) {
                          print('Error accessing Hive box: $e');
                          scaffoldMessage.showSnackBar(SnackBar(
                            content: Text('Error saving data. Please try again.'),
                          ));
                        }
                      },


                      child: Text('Add',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)),

                  h20,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
