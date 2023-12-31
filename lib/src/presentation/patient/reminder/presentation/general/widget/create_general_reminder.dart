import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/presentation/patient/reminder/domain/model/general_reminder_model.dart';
import 'package:medical_app/src/presentation/patient/reminder/domain/model/reminder_model.dart';

import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/style_manager.dart';
import '../../../../../../core/resources/value_manager.dart';
import '../../../../../common/snackbar.dart';
import '../../../../../login/domain/model/user.dart';
import '../../../../../notification_controller/notification_controller.dart';
import '../../../data/reminder_db.dart';


class CreateGeneralReminder extends ConsumerStatefulWidget {


  @override
  _EditReminderPageState createState() => _EditReminderPageState();
}

class _EditReminderPageState extends ConsumerState<CreateGeneralReminder> {


  int page = 0;
  PageController _pageController = PageController(initialPage: 0);





  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();


  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _initialReminderController = TextEditingController();
  TextEditingController _intervalDurationController = TextEditingController();



  String? selectedPatternName;
  int? selectedPatternId;
  // List<String> selectedDays = [];

  DateTime? startDateIntake;


  String selectedInitialReminderType=initialReminderType[0];
  int selectedInitialReminderTypeId=0;

  List<String>? days;





  List<bool>? isSelected;
  // List<bool> isSelected = [false, false, false, false, false, false, false];


  bool selectDaysValidation = false;




  @override
  void initState() {
    super.initState();








  }

  void _addReminder(GeneralReminderModel reminder) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    final reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');

      await reminderBox.add(reminder);
    scaffoldMessage.showSnackBar(
      SnackbarUtil.showSuccessSnackbar(
        message: 'Reminder saved !',
        duration: const Duration(milliseconds: 1400),
      ),
    );

    Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen

  }

  TimeOfDay _parseTime(String timeString) {
    final parsedTime = DateFormat('hh:mm a').parse(timeString);
    return TimeOfDay(
      hour: parsedTime.hour,
      minute: parsedTime.minute,
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTimeController.text.isNotEmpty ? _parseTime(
          _startTimeController.text) : TimeOfDay.now(),
    );

    if (picked != null) {
      var selectedTime = TimeOfDay(
        hour: picked.hour,
        minute: picked.minute,
      );

      final formattedTime = selectedTime.format(context);

      _startTimeController.text = formattedTime;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {


      DateTime date = DateFormat('hh:mm a').parse(_startTimeController.text);
      DateTime now = DateTime.now();

      date = DateTime(now.year, now.month, now.day, date.hour, date.minute);


      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate:date.isBefore(now) ? now.add(Duration(days: 1)) :DateTime.now(),
        firstDate: date.isBefore(now) ? now.add(Duration(days: 1)) :DateTime.now(),
        lastDate: DateTime(2101),
      );

      if(selectedDate != null){
        setState(() {
          startDateIntake = selectedDate;
        });
        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        _startDateController.text = formattedDate;
      }


  }


  @override
  Widget build(BuildContext context) {

    // TabController _tabController = TabController(length: 2, vsync: this);
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryDark,
          elevation: 0,
          toolbarHeight: 100,
          centerTitle: true,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          title: Container(
              width: double.infinity,
              height: 100,

              child: Stack(
                children: [
                  Positioned(
                      top: 20,
                      right: 60,

                      child: Transform.rotate(
                          angle: 320 * 3.14159265358979323846 / 180,
                          child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.2),size: 70,))
                  ),
                  Positioned(
                      top: 20,
                      left: 40,
                      child: Transform.rotate(
                          angle: 30 * 3.14159265358979323846 / 180,
                          child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white.withOpacity(0.2),size: 80,))
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: FaIcon(Icons.chevron_left, color: ColorManager.white,size: 30,
                      ),
                    ),
                  ),
                  Center(child: Text('Set a Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
                ],
              )),

        ),
        body:  Container(
          height: 900,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            color: ColorManager.white,
          ),
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Form(
            key: formKey1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                h20,
                h20,
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.blueText
                        )
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primaryDark
                        )
                    ),
                    labelText: 'Title',
                    labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Title is required';
                    }
                    if(RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)){
                      return 'Invalid title';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value){
                    // ref.read(itemProvider.notifier).updateMedicineName(value);
                  },

                ),
                h10,
                TextFormField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.blueText
                        )
                    ),
                    enabledBorder:  OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primaryDark
                        )
                    ),
                    labelText: 'Description',
                    labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                  ),
                  validator: (value){
                    if(value!.trim().isEmpty){
                      return 'Description is required';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (value){
                    // ref.read(itemProvider.notifier).updateMedicineName(value);
                  },

                ),

                h10,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _startTimeController,
                        readOnly: true, // Make the field read-only
                        onTap: ()=>  _selectTime(context), // Show time picker when tapped
                        decoration: InputDecoration(
                          suffixIconConstraints: BoxConstraints.tightForFinite(),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 18.w),
                            child: FaIcon(
                              Icons.access_time,
                              color: ColorManager.blueText,
                              size: 24.sp,
                            ),
                          ),
                          labelText: 'Schedule Time',
                          labelStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
                          hintText: 'hh:mm',
                          hintStyle: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorManager.primaryDark,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorManager.primaryDark,
                            ),
                          ),
                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return 'Please select a Time';
                          }


                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    w10,
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context), // Show date picker for start date when tapped
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startDateController,
                            decoration: InputDecoration(
                              suffixIconConstraints: BoxConstraints.tightForFinite(),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FaIcon(Icons.calendar_month,color: ColorManager.primaryDark,),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.blueText)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.primaryDark)),
                              labelText: 'Start Date',
                              labelStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please select a start date';
                              }
                              return null;
                            },
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),


                h10,
                DropdownButtonFormField(

                  menuMaxHeight: 250,
                  isDense: true,
                  decoration: InputDecoration(

                      isDense: true,
                      labelText: 'Reminder Pattern',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primaryDark
                          )
                      ),

                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primaryDark
                          )
                      )
                  ),
                  value: selectedPatternName ,

                  items: generalPatternList
                      .map(
                        (ReminderPatternModel item) => DropdownMenuItem<String>(
                      value: item.patternName,
                      child: Text(
                        item.patternName,
                        style: getRegularStyle(color: Colors.black,fontSize: 16.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ).toList(),
                  onChanged: (value){
                    setState(() {
                      selectedPatternName = value!;
                      selectedPatternId = generalPatternList.firstWhere((element) => element.patternName == value).id;
                      isSelected = [false, false, false, false, false, false, false];
                      selectDaysValidation = false;
                    });

                    //ref.read(itemProvider.notifier).updatePatternId(patternList.firstWhere((element) => element.patternName == value).id);

                  },
                  validator: (value){
                    if(selectedPatternName == null){
                      return 'Reminder Pattern is required';
                    }

                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                if(selectedPatternId == 4)
                h10,
                if(selectedPatternId == 4)
                  TextFormField(
                    controller: _intervalDurationController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.blueText
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primaryDark
                          )
                      ),
                      labelText: 'Interval of Days',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Interval is required';
                      }
                      if (!value.contains(RegExp(r'^\d+$'))) {
                        return 'Invalid value';
                      }
                      if(int.parse(value) <= 0){
                        return 'Interval must be more than 0';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,

                  ),

                if(selectedPatternId == 4)
                  h10,
                if(selectedPatternId == 3)
                  h10,


                if(selectedPatternId == 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: daysOfWeekMedication.asMap().entries.map((entry) {
                      final index = entry.key;
                      final day = entry.value;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            isSelected![index] = !isSelected![index];
                            selectDaysValidation = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: isSelected![index]
                                ? ColorManager.primaryDark
                                : ColorManager.dotGrey.withOpacity(0.5), // Selected and unselected colors
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Text(
                            '${day.substring(0, 3)}',
                            style: TextStyle(
                              color: isSelected![index]
                                  ? ColorManager.white
                                  : Colors.black, // Text color when selected and unselected
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                if(selectDaysValidation == true)
                  h10,

                if(selectDaysValidation == true)
                  Text('Select at least one day',style: TextStyle(color: ColorManager.red.withOpacity(0.7)),),

                h10,


                if(selectedPatternId == 3)
                  h10,

                if(selectedPatternId == 1 || selectedPatternId == 2)
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(' Remind me before (optional)',style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),)),
                if(selectedPatternId == 1 || selectedPatternId == 2)
                h10,
                if(selectedPatternId == 1 || selectedPatternId == 2)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [


                    Expanded(
                      child: TextFormField(
                        controller: _initialReminderController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.blueText
                              )
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.primaryDark
                              )
                          ),

                        ),
                        validator: (value){
                          if(value!.isEmpty){
                            return null;
                          }
                          if(selectedInitialReminderTypeId == 3){
                            if(int.parse(value)>7){
                              return 'Days must be less than 8';
                            }
                          }
                          if(selectedInitialReminderTypeId == 2){
                            if(int.parse(value)>24){
                              return 'Hours must be less than 24';
                            }
                          }
                          if(selectedInitialReminderTypeId == 1){
                            if(int.parse(value)>60){
                              return 'Minutes must be less than 60';
                            }
                          }
                          if (!value.contains(RegExp(r'^\d+$'))) {
                            return 'Invalid value';
                          }
                          else if (int.parse(value) <= 0) {
                            return 'Must be greater than 0';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value){
                          // ref.read(itemProvider.notifier).updateStrength(value);
                        },
                      ),
                    ),
                    w10,
                    Expanded(
                      child: DropdownButtonFormField(
                        menuMaxHeight: 200,
                        isDense: true,
                        value:selectedInitialReminderType ,
                        decoration: InputDecoration(

                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.primaryDark
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.primaryDark
                                )
                            )
                        ),

                        items: initialReminderType
                            .map(
                              (String item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: getRegularStyle(color: Colors.black,fontSize: 16.sp),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ).toList(),
                        onChanged: (value){
                          setState(() {
                            selectedInitialReminderType = value!;
                            selectedInitialReminderTypeId = initialReminderType.indexOf(value);
                          });
                          // ref.read(itemProvider.notifier).updateStrengthUnit(value!);

                        },
                        validator: (value){
                          if(_initialReminderController.text.isNotEmpty){
                            if(selectedInitialReminderType == null){
                              return 'Please select a unit';
                            }

                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                  ],
                ),
                if(selectedPatternId == 1 || selectedPatternId == 2)
                h10,
                h10,
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: ColorManager.black.withOpacity(0.7)
                          ),
                          onPressed: ()=>Get.back(), child: Text('Cancel',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                    ),
                    w10,
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primaryDark
                          ),
                          onPressed: ()async{

                            final scaffoldMessage = ScaffoldMessenger.of(context);
                            final userBox = Hive.box<User>('session').values.toList();
                            int userId = userBox[0].id!;

                            List<String> list = [];

                            // selectedDays.clear(); // Clear the list before populating it

                            if(isSelected != null){
                              for (int i = 0; i < isSelected!.length; i++) {

                                if (isSelected![i]) {
                                  print(daysOfWeekMedication[i]);
                                  list.add(daysOfWeekMedication[i]);


                                  // selectedDays.add(daysOfWeekMedication[i]);
                                }
                              }
                            }

                            setState(() {
                              days = list;
                            });


                            if(selectedPatternId == 3 && days!.isEmpty ){
                              setState(() {
                                selectDaysValidation = true;
                              });
                              scaffoldMessage.showSnackBar(
                                SnackbarUtil.showFailureSnackbar(
                                  message: 'Please select a day',
                                  duration: const Duration(milliseconds: 1400),
                                ),
                              );
                            }
                            else{
                              print('executed');
                              if(formKey1.currentState!.validate()){

                                GeneralReminderModel reminder = GeneralReminderModel(
                                    reminderId: Random().nextInt(1000),
                                    title: _titleController.text.trim(),
                                    description: _descriptionController.text,
                                    time: _startTimeController.text.trim(),
                                    startDate: startDateIntake!,
                                    initialReminder:_initialReminderController.text.isEmpty?null: InitialReminder(
                                        initialReminderTypeId: selectedInitialReminderTypeId,
                                        initialReminderTypeName: selectedInitialReminderType,
                                        initialReminder:int.parse(_initialReminderController.text.trim())),
                                    reminderPattern:ReminderPattern(
                                        reminderPatternId: selectedPatternId!,
                                        patternName: selectedPatternName!,
                                        interval: selectedPatternId == 4 ? int.parse(_intervalDurationController.text) : null,
                                        daysOfWeek: selectedPatternId == 3 ? days : null
                                    ) ,
                                    userId: userId
                                );

                                // if(selectedPatternId == 1){
                                //   NotificationService().scheduleEverydayNotification(reminder: reminder);
                                // }
                                // else if(selectedPatternId == 2){
                                //   NotificationService().scheduleSpecificDaysNotification(reminder: reminder);
                                // }
                                // else if(selectedPatternId == 3){
                                //   NotificationService().scheduleIntervalSNotification(reminder: reminder);
                                // }


                                // print(reminder.title);
                                // print(reminder.description);
                                // print(reminder.time);
                                // print(reminder.startDate);
                                // print(reminder.reminderPattern.patternName);

                                await  NotificationController.scheduleGeneralNotification(context,reminder: reminder);


                                _addReminder(reminder);
                              }


                            }


                          }, child: Text('Save',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                    ),
                  ],
                ),


                h100,




              ],
            ),
          ),
          ),
        ),
      ),
    );
  }



}


