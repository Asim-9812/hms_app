import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/general_reminder_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/reminder_model.dart';

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

  DateTime? setTime ;



  List<String>? days;



  String selectedInitialReminderType = 'min';
  int selectedInitialReminderTypeId = 1;




  List<bool>? isSelected;
  // List<bool> isSelected = [false, false, false, false, false, false, false];


  bool selectDaysValidation = false;

  List<DateTime> scheduledDate = [];

  List<int> contentList = [];


  bool isPostingData = false;

  bool remindMe = false;





  @override
  void initState() {
    super.initState();








  }

  void _addReminder(GeneralReminderModel reminder) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    final reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');
    print('reminder id : ${reminder.reminderId}');

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
    final scaffoldMessage = ScaffoldMessenger.of(context);
    if(_startDateController.text.isEmpty){
      scaffoldMessage.showSnackBar(
        SnackbarUtil.showFailureSnackbar(
          message: 'Please select a date first',
          duration: const Duration(milliseconds: 1400),
        ),
      );
    }
    else{
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        var selectedTime = TimeOfDay(
          hour: picked.hour,
          minute: picked.minute,
        );
        final now = DateTime.now();

        final formattedTime = selectedTime.format(context);
        setState(() {
          setTime = DateTime(now.year,now.month,now.day,selectedTime.hour,selectedTime.minute);
        });

        _startTimeController.text = formattedTime;
      }
    }




  }

  Future<void> _selectStartDate(BuildContext context) async {





      DateTime now = DateTime.now();


      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate:startDateIntake == null ? DateTime.now() : startDateIntake,
        firstDate: DateTime.now(),
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
                     focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primary
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
                     focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.primary
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
                      child: GestureDetector(
                        onTap: () => _selectStartDate(context), // Show date picker for start date when tapped
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startDateController,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: ColorManager.black.withOpacity(0.5)
                                  )
                              ),
                              suffixIconConstraints: BoxConstraints.tightForFinite(),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: FaIcon(Icons.calendar_month,color: ColorManager.primaryDark,),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.primary)),
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
                    w10,
                    Expanded(
                      child: TextFormField(
                        controller: _startTimeController,
                        readOnly: true, // Make the field read-only
                        onTap: ()=>  _selectTime(context), // Show time picker when tapped
                        decoration: InputDecoration(
                           focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                          suffixIconConstraints: BoxConstraints.tightForFinite(),
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(right: 18.w),
                            child: FaIcon(
                              Icons.access_time,
                              color: ColorManager.primary,
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
                          if(startDateIntake!.isAtSameMomentAs(DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day)) && setTime!.isBefore(DateTime.now())){
                            return 'Time cannot be in the past';

                          }


                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),



                  ],
                ),


                h20,
                DropdownButtonFormField(

                  menuMaxHeight: 250,
                  isDense: true,
                  decoration: InputDecoration(
                     focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),

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
                    if(selectedPatternId == 3 || selectedPatternId == 4){
                      setState(() {
                        remindMe = false;
                      });
                    }

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
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
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


                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Remind me before'),
                    Checkbox(
                        value: remindMe,
                        onChanged: (value){
                          setState(() {
                            remindMe =!remindMe ;
                          });
                        }
                    )
                  ],
                ),

                if(remindMe)
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _initialReminderController,
                          decoration: InputDecoration(
                            labelText: 'Remind me',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            
                          ),
                          validator: (value){
                            if(_startDateController.text.isEmpty || _startTimeController.text.isEmpty){
                              return 'Please set the date & time first';
                            }
                            else{
                              final now = DateTime.now();

                              DateTime validDate = DateTime(startDateIntake!.year,startDateIntake!.month,startDateIntake!.day,setTime!.hour,setTime!.minute);


                              if(value!.trim().isEmpty){
                                return 'Time is required';
                              }
                              else{
                                try{
                                  final int addTime = int.parse(_initialReminderController.text.trim());
                                  if(selectedInitialReminderTypeId == 1){
                                    final addedTime = validDate.subtract(Duration(minutes: addTime));

                                    if(addedTime.isBefore(now)){
                                      return 'Initial reminder cannot be before current date';
                                    }
                                  }
                                  else if(selectedInitialReminderTypeId == 2){
                                    final addedTime = validDate.subtract(Duration(hours: addTime));

                                    if(addedTime.isBefore(now)){
                                      return 'Initial reminder cannot be before current date';
                                    }
                                  }
                                  else if(selectedInitialReminderTypeId == 3){
                                    final addedTime = validDate.subtract(Duration(days: addTime));

                                    if(addedTime.isBefore(now)){
                                      return 'Initial reminder cannot be before current date';
                                    }
                                  }

                                } catch(e) {
                                  return 'Invalid Time';
                                }
                              }

                            }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      w10,
                      SizedBox(
                        width: 100,
                        child: DropdownButtonFormField(

                          menuMaxHeight: 250,
                          isDense: true,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: ColorManager.black.withOpacity(0.5)
                                  )
                              ),

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
                          value: selectedInitialReminderType ,

                          items: initialReminderType
                              .map(
                                (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ).toList(),
                          onChanged: (value){
                            final index = initialReminderType.indexOf(value!) + 1;
                            setState(() {
                              selectedInitialReminderType = value;
                              selectedInitialReminderTypeId = index;
                            });

                            //ref.read(itemProvider.notifier).updatePatternId(patternList.firstWhere((element) => element.patternName == value).id);

                          },
                          validator: (value){
                            // if(selectedInitialReminderType == null){
                            //   return 'Reminder Pattern is required';
                            // }

                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      
                    ],
                  ),


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
                            String userId = userBox[0].username!;

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
                              if(formKey1.currentState!.validate()) {
                                setState(() {
                                  isPostingData = true;
                                });

                                int addedTime = 0;

                                Duration? duration ;

                                if(remindMe){
                                  addedTime = int.parse(_initialReminderController.text.trim());
                                  if(selectedInitialReminderTypeId == 1){
                                    duration = Duration(minutes: addedTime);
                                  }
                                  else if(selectedInitialReminderTypeId == 2){
                                    duration = Duration(hours: addedTime);
                                  }
                                  else if(selectedInitialReminderTypeId == 3){
                                    duration = Duration(days: addedTime);
                                  }
                                }

                                /// FOR ONCE....
                                if (selectedPatternId == 1) {
                                  final DateTime firstDate = DateTime(
                                      startDateIntake!.year,
                                      startDateIntake!.month,
                                      startDateIntake!.day,
                                      setTime!.hour, setTime!.minute);

                                  final initialDate = firstDate.subtract(remindMe? duration! : Duration(seconds: 0));
                                  int contentId = Random().nextInt(9999);




                                    final NotificationContent content = NotificationContent(
                                      id: contentId,
                                      channelKey: 'general_alerts',
                                      title: _titleController.text.trim(),
                                      body: _descriptionController.text,
                                      notificationLayout: NotificationLayout
                                          .Default,
                                      color: Colors.black,
                                      category: NotificationCategory.Alarm,
                                      timeoutAfter: Duration(minutes: 1),

                                      wakeUpScreen: true,


                                      //
                                      backgroundColor: Colors.black,
                                      // customSound: 'resource://raw/notif',
                                      payload: {
                                        'reminderTypeId': '2',
                                        'dateTime': firstDate.toString()
                                      },
                                    );

                                    final NotificationCalendar schedule = NotificationCalendar(
                                year: firstDate.year,
                                month: firstDate.month,
                                day: firstDate.day,
                                hour: firstDate.hour,
                                minute: firstDate.minute,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                              );



                                    await NotificationController
                                        .scheduleNotifications(


                                        schedule: schedule,
                                        content: content);
                                  final initialContentId = Random().nextInt(9999);

                                  if(remindMe){


                                      final NotificationContent initialContent = NotificationContent(
                                        id: initialContentId,
                                        channelKey: 'general_alerts',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        wakeUpScreen: true,


                                        //
                                        backgroundColor: Colors.black,

                                      );

                                      final NotificationCalendar schedule = NotificationCalendar(
                                year: initialDate.year,
                                month: initialDate.month,
                                day: initialDate.day,
                                hour: initialDate.hour,
                                minute: initialDate.minute,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                            );

                                      await NotificationController
                                          .scheduleInitialNotifications(
                                          schedule: schedule,
                                          content: initialContent);

                                  }
                                  GeneralReminderModel reminder = GeneralReminderModel(
                                      reminderId: Random().nextInt(9999),
                                      title: _titleController.text.trim(),
                                      description: _descriptionController.text,
                                      time: _startTimeController.text.trim(),
                                      startDate: startDateIntake!,
                                      reminderPattern: ReminderPattern(
                                        reminderPatternId: selectedPatternId!,
                                        patternName: selectedPatternName!,
                                      ),
                                      initialReminder: !remindMe ? null : InitialReminder(
                                        initialReminderContentId: initialContentId,
                                          initialReminderTypeId: selectedInitialReminderTypeId,
                                          initialReminderTypeName: selectedInitialReminderType,
                                          initialReminder: int.parse(_initialReminderController.text.trim())
                                      ),
                                      userId: userId,
                                      contentId: contentId,
                                      reminderTypeId: 2
                                  );




                                  _addReminder(reminder);
                                }

                                /// FOR EVERYDAY....
                                if (selectedPatternId == 2) {
                                  final DateTime firstDate = DateTime(
                                      startDateIntake!.year,
                                      startDateIntake!.month,
                                      startDateIntake!.day,
                                      setTime!.hour, setTime!.minute);

                                  final initialDate = firstDate.subtract(remindMe? duration! : Duration(seconds: 0));

                                  int contentId =Random().nextInt(9999);

                                    final NotificationContent content = NotificationContent(
                                      id: contentId,
                                      channelKey: 'general_alerts',
                                      title: _titleController.text.trim(),
                                      body: _descriptionController.text,
                                      notificationLayout: NotificationLayout
                                          .Default,
                                      color: Colors.black,
                                      category: NotificationCategory.Alarm,
                                      timeoutAfter: Duration(minutes: 1),

                                      wakeUpScreen: true,

                                      //
                                      backgroundColor: Colors.black,
                                      // customSound: 'resource://raw/notif',
                                      payload: {
                                        'reminderTypeId': '2',
                                        'dateTime': firstDate.toString()
                                      },
                                    );

                                    final NotificationCalendar schedule = NotificationCalendar(
                                year: firstDate.year,
                                month: firstDate.month,
                                day: firstDate.day,
                                hour: firstDate.hour,
                                minute: firstDate.minute,
                                repeats: true,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                              );

                                    contentList.add(content.id!);

                                    await NotificationController
                                        .scheduleNotifications(
                                         schedule: schedule,
                                        content: content);
                                  final initialContentId = Random().nextInt(9999);

                                  if(remindMe){

                                      final NotificationContent content = NotificationContent(
                                        id: initialContentId,
                                        channelKey: 'general_alerts',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        wakeUpScreen: true,


                                        //
                                        backgroundColor: Colors.black,

                                      );

                                      final NotificationCalendar schedule = NotificationCalendar(
                                year: initialDate.year,
                                month: initialDate.month,
                                day: initialDate.day,
                                hour: initialDate.hour,
                                minute: initialDate.minute,
                                repeats: true,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                            );


                                      contentList.add(content.id!);

                                      await NotificationController
                                          .scheduleInitialNotifications(

                                          schedule: schedule,
                                          content: content);


                                  }

                                  GeneralReminderModel reminder = GeneralReminderModel(
                                      reminderId: Random().nextInt(9999),
                                      title: _titleController.text.trim(),
                                      description: _descriptionController.text,
                                      time: _startTimeController.text.trim(),
                                      startDate: startDateIntake!,
                                      reminderPattern: ReminderPattern(
                                        reminderPatternId: selectedPatternId!,
                                        patternName: selectedPatternName!,
                                      ),
                                      userId: userId,
                                      contentId: contentId,
                                    reminderTypeId: 2,
                                    initialReminder: !remindMe ? null : InitialReminder(
                                      initialReminderContentId: initialContentId,
                                        initialReminderTypeId: selectedInitialReminderTypeId,
                                        initialReminderTypeName: selectedInitialReminderType,
                                        initialReminder: int.parse(_initialReminderController.text.trim())
                                    ),
                                  );


                                  _addReminder(reminder);
                                }


                                /// FOR Specific days....
                                if (selectedPatternId == 3) {
                                  final DateTime firstDate = DateTime(
                                      startDateIntake!.year,
                                      startDateIntake!.month,
                                      startDateIntake!.day,
                                      setTime!.hour, setTime!.minute);

                                  final initialDate = firstDate.subtract(remindMe? duration! : Duration(seconds: 0));

                                  int contentId = Random().nextInt(9999);
                                  int initialContentId = Random().nextInt(9999);

                                  final NotificationContent content = NotificationContent(
                                    id: contentId,
                                    channelKey: 'general_alerts',
                                    title: _titleController.text.trim(),
                                    body: _descriptionController.text,
                                    notificationLayout: NotificationLayout
                                        .Default,
                                    color: Colors.black,

                                    //
                                    backgroundColor: Colors.black,
                                    category: NotificationCategory.Alarm,
                                    timeoutAfter: Duration(minutes: 1),

                                    wakeUpScreen: true,

                                    // customSound: 'resource://raw/notif',
                                    payload: {
                                      'reminderTypeId': '2',
                                      'dateTime': firstDate.toString()
                                    },
                                  );


                                  final NotificationCalendar schedule = NotificationCalendar(
                                      year: firstDate.year,
                                      month: firstDate.month,
                                      day: firstDate.day,
                                      hour: firstDate.hour,
                                      minute: firstDate.minute,
                                      timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                                  );



                                  await NotificationController.scheduleNotifications(
                                      schedule: schedule,
                                      content: content);

                                  if(remindMe){
                                    final NotificationContent initialContent = NotificationContent(
                                      id: initialContentId,
                                      channelKey: 'general_alerts',
                                      title: _titleController.text.trim(),
                                      body: _descriptionController.text,
                                      notificationLayout: NotificationLayout
                                          .Default,
                                      color: Colors.black,

                                      wakeUpScreen: true,


                                      //
                                      backgroundColor: Colors.black,

                                    );

                                    final NotificationCalendar schedule = NotificationCalendar(
                                        year: initialDate.year,
                                        month: initialDate.month,
                                        day: initialDate.day,
                                        hour: initialDate.hour,
                                        minute: initialDate.minute,
                                        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                                    );

                                    await NotificationController.scheduleInitialNotifications(
                                        schedule: schedule,
                                        content: initialContent);


                                  }





                                  for(var i in days!){
                                    final indexOfWeek = daysOfWeekMedication.indexOf(i) +1;
                                    final NotificationContent content = NotificationContent(
                                      id: contentId,
                                      channelKey: 'general_alerts',
                                      title: _titleController.text.trim(),
                                      body: _descriptionController.text,
                                      notificationLayout: NotificationLayout
                                          .Default,
                                      color: Colors.black,

                                      //
                                      backgroundColor: Colors.black,
                                      category: NotificationCategory.Alarm,
                                      timeoutAfter: Duration(minutes: 1),

                                      wakeUpScreen: true,

                                      // customSound: 'resource://raw/notif',
                                      payload: {
                                        'reminderTypeId': '2',
                                        'dateTime': firstDate.toString()
                                      },
                                    );


                                    final NotificationCalendar schedule = NotificationCalendar(
                                      weekday: indexOfWeek,
                                        repeats: true,
                                        timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                                    );



                                    await NotificationController.scheduleNotifications(
                                        schedule: schedule,
                                        content: content);


                                    if(remindMe){
                                      final NotificationContent initialContent = NotificationContent(
                                        id: initialContentId,
                                        channelKey: 'general_alerts',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        wakeUpScreen: true,


                                        //
                                        backgroundColor: Colors.black,

                                      );

                                      final NotificationCalendar schedule = NotificationCalendar(
                                        weekday: indexOfWeek,
                                          repeats: true,
                                          timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                                      );

                                      await NotificationController.scheduleInitialNotifications(
                                          schedule: schedule,
                                          content: initialContent);


                                    }


                                  }




                                  GeneralReminderModel reminder = GeneralReminderModel(
                                      reminderId: Random().nextInt(1000),
                                      title: _titleController.text.trim(),
                                      description: _descriptionController.text,
                                      time: _startTimeController.text.trim(),
                                      startDate: startDateIntake!,
                                      reminderPattern: ReminderPattern(
                                          reminderPatternId: selectedPatternId!,
                                          patternName: selectedPatternName!,
                                          daysOfWeek: selectedPatternId == 3
                                              ? days
                                              : null
                                      ),
                                      userId: userId,
                                      contentId: contentId,
                                    initialContentId: initialContentId,
                                    initialReminder: !remindMe ? null : InitialReminder(
                                        initialReminderContentId: initialContentId,
                                        initialReminderTypeId: selectedInitialReminderTypeId,
                                        initialReminderTypeName: selectedInitialReminderType,
                                        initialReminder: int.parse(_initialReminderController.text.trim())
                                    ),
                                    reminderTypeId: 2
                                  );


                                  _addReminder(reminder);
                                }


                                /// FOR INTERVALS....
                                if (selectedPatternId == 4) {
                                  final initialInterval = int.parse(_intervalDurationController.text) *24 *60 *60;
                                  final DateTime firstDate = DateTime(
                                      startDateIntake!.year,
                                      startDateIntake!.month,
                                      startDateIntake!.day,
                                      setTime!.hour, setTime!.minute);

                                  int contentId = Random().nextInt(9999);
                                  int initialContentId = Random().nextInt(9999);

                                  final initialDate = firstDate.subtract(remindMe? duration! : Duration(seconds: 0));

                                    final NotificationContent content = NotificationContent(
                                      id: contentId,
                                      channelKey: 'general_alerts',
                                      title: _titleController.text.trim(),
                                      body: _descriptionController.text,
                                      notificationLayout: NotificationLayout
                                          .Default,
                                      color: Colors.black,
                                      category: NotificationCategory.Alarm,
                                      timeoutAfter: Duration(minutes: 1),

                                      wakeUpScreen: true,


                                      //
                                      backgroundColor: Colors.black,
                                      // customSound: 'resource://raw/notif',
                                      payload: {
                                        'reminderTypeId': '2',
                                        'dateTime': firstDate.toString()
                                      },
                                    );


                                    final NotificationCalendar schedule = NotificationCalendar(
                                year: firstDate.year,
                                month: firstDate.month,
                                day: firstDate.day,
                                hour: firstDate.hour,
                                minute: firstDate.minute,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                              );

                                    contentList.add(content.id!);

                                    await NotificationController
                                        .scheduleNotifications(
                                         schedule: schedule,
                                        content: content);


                                  if(remindMe){
                                      final NotificationContent initialContent = NotificationContent(
                                        id: initialContentId,
                                        channelKey: 'general_alerts',
                                        title: _titleController.text.trim(),
                                        body: _descriptionController.text,
                                        notificationLayout: NotificationLayout
                                            .Default,
                                        color: Colors.black,

                                        wakeUpScreen: true,


                                        //
                                        backgroundColor: Colors.black,
                                      );

                                      final NotificationCalendar initialSchedule = NotificationCalendar(
                                year: initialDate.year,
                                month: initialDate.month,
                                day: initialDate.day,
                                hour: initialDate.hour,
                                minute: initialDate.minute,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                            );



                                      final NotificationInterval initialIntervals = NotificationInterval(interval: initialInterval,repeats: true,);



                                      await NotificationController
                                          .scheduleInitialNotifications(
                                          schedule: initialSchedule,
                                          content: initialContent);
                                  }

                                  GeneralReminderModel reminder = GeneralReminderModel(
                                      reminderId: Random().nextInt(1000),
                                      title: _titleController.text.trim(),
                                      description: _descriptionController.text,
                                      time: _startTimeController.text.trim(),
                                      startDate: startDateIntake!,
                                      reminderPattern: ReminderPattern(
                                        reminderPatternId: selectedPatternId!,
                                        patternName: selectedPatternName!,
                                        interval: selectedPatternId == 4
                                            ? int.parse(
                                            _intervalDurationController.text)
                                            : null,
                                      ),
                                      userId: userId,
                                      contentId: contentId,
                                      initialContentId: initialContentId,
                                      initialReminder: !remindMe ? null : InitialReminder(
                                          initialReminderContentId: initialContentId,
                                          initialReminderTypeId: selectedInitialReminderTypeId,
                                          initialReminderTypeName: selectedInitialReminderType,
                                          initialReminder: int.parse(_initialReminderController.text.trim())
                                      ),
                                      reminderTypeId: 2
                                  );


                                  _addReminder(reminder);
                                }
                              }


                            }


                          }, child:isPostingData? SpinKitDualRing(color: ColorManager.white,size: 16,): Text('Save',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
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


