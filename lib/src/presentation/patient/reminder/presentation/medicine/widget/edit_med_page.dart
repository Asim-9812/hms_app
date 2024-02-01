import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/reminder_model.dart';
import '../../../../../notification_controller/notification_controller.dart';
import '../../../../../../core/resources/color_manager.dart';
import '../../../../../../core/resources/style_manager.dart';
import '../../../../../../core/resources/value_manager.dart';
import '../../../../../../data/provider/common_provider.dart';
import '../../../../../common/snackbar.dart';
import '../../../data/reminder_db.dart';
import '../../../domain/services/med_services.dart';



class EditMedReminderPage extends ConsumerStatefulWidget {
  final Reminder reminderTest;

  EditMedReminderPage(this.reminderTest);

  @override
  _EditReminderPageState createState() => _EditReminderPageState();
}

class _EditReminderPageState extends ConsumerState<EditMedReminderPage> {
  late Reminder updatedReminder;

  int page = 0;
  PageController _pageController = PageController(initialPage: 0);





  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();


  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _strengthController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _medicationDurationController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _intervalDurationController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  TextEditingController _noteController = TextEditingController();


  late int selectedMedTypeId;
  late String selectedMedTypeName;
  String? selectedStrengthUnit;
  late String selectedFrequencyName;
  late List<String> scheduleTime;
  List<String> notifyScheduleTime =[];
  late String intervals;
  late int frequencyId;
  late DateTime endDateIntake;
  late DateTime startDateIntake;
  late int selectedMealId;
  late String selectedMealName;
  late String selectedPatternName;
  late int selectedPatternId;
  // List<String> selectedDays = [];

  List<String>? days;
  late int imageSet;

  late int contentId ;
  late int initialContentId ;





  List<bool>? isSelected;
  // List<bool> isSelected = [false, false, false, false, false, false, false];


  bool selectDaysValidation = false;

  late DateTime newTime;
  late TimeOfDay selectedTime;

  bool isPostingData = false;




  @override
  void initState() {
    super.initState();
    // Initialize the updatedReminder with the data from Hive
    updatedReminder = widget.reminderTest;
    selectedMedTypeId = updatedReminder.medTypeId;
    selectedMedTypeName = updatedReminder.medTypeName;
    _medicineNameController.text = updatedReminder.medicineName;
    _strengthController.text = updatedReminder.strength.toString();
    selectedStrengthUnit = updatedReminder.unit;
    selectedFrequencyName = updatedReminder.frequency.frequencyName;
    frequencyId = updatedReminder.frequency.frequencyId;
    intervals = updatedReminder.frequency.intervals;
    scheduleTime = updatedReminder.scheduleTime;
    _startTimeController.text = updatedReminder.scheduleTime.first;
    _medicationDurationController.text = updatedReminder.medicationDuration.toString();
    _startDateController.text = DateFormat('yyyy-MM-dd').format(updatedReminder.startDate);
    _endDateController.text = DateFormat('yyyy-MM-dd').format(updatedReminder.endDate);
    startDateIntake =updatedReminder.startDate;
    endDateIntake =updatedReminder.endDate;
    selectedMealId =updatedReminder.mealTypeId;
    selectedMealName =updatedReminder.meal;
    selectedPatternName = updatedReminder.reminderPattern.patternName;
    selectedPatternId = updatedReminder.reminderPattern.reminderPatternId;
    if(updatedReminder.reminderPattern.interval != null){
      _intervalDurationController.text = updatedReminder.reminderPattern.interval.toString();
    }

    if(updatedReminder.reminderPattern.daysOfWeek != null){
      days = updatedReminder.reminderPattern.daysOfWeek;
      isSelected = [
        days!.contains('Monday'),
        days!.contains('Tuesday'),
        days!.contains('Wednesday'),
        days!.contains('Thursday'),
        days!.contains('Friday'),
        days!.contains('Saturday'),
        days!.contains('Sunday'),
      ];
    }


     imageSet = updatedReminder.reminderImage != null ? 1:2;



    if(updatedReminder.notes != null){
      _noteController.text = updatedReminder.notes!;
    }


    _summaryController.text = '${selectedMedTypeName} ${_medicineNameController.text} ${_strengthController.text}${selectedStrengthUnit} ${selectedFrequencyName} ${selectedPatternName}';


    contentId = widget.reminderTest.contentId;
    initialContentId = widget.reminderTest.initialContentId;

    newTime =_getDate(scheduleTime[0]);
    print(newTime);
    selectedTime = TimeOfDay(hour: newTime.hour, minute: newTime.minute);

    WidgetsBinding.instance.addPostFrameCallback((_) {

      forNotifyScheduleTime();
    });




  }

  DateTime _getDate(String setDate){
    try{
      final date= DateFormat('hh:mm a').parse(setDate);
      return date;
    }catch (e){
      final date = DateFormat('hh:mm').parse(setDate);
      return date;
    }
  }

  void _updateReminder(Reminder reminder) {
    final reminderBox = Hive.box<Reminder>('med_reminder');
    // Get the index of the reminder to update based on its 'reminderId' (you should replace 1002 with the actual 'reminderId' you want to update)
    final int indexToUpdate = reminderBox.values.toList().indexWhere((element) => element.reminderId == updatedReminder.reminderId);

    if (indexToUpdate != -1) {
      // If the reminder is found, update it
      reminderBox.putAt(indexToUpdate, reminder);
      setState(() {
        isPostingData = false;
      });
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Reminder not found for update.');
    }
  }


  void forNotifyScheduleTime(){

    final formattedTime = DateFormat('HH:mm a').format(
      DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute),
    );

    // Calculate intake times based on selected frequencyId
    notifyScheduleTime.clear(); // Clear the list before adding new times

    // Add the initial selected time
    notifyScheduleTime.add(formattedTime);

    // Calculate additional times based on frequencyId
    if (frequencyId >= 1) {
      // Calculate intervals based on frequencyId
      int intervalHours = 24 ~/ frequencyId;

      for (int i = 1; i < frequencyId; i++) {
        // Add intervals to the selected time and add to the list
        selectedTime = TimeOfDay(
          hour: (selectedTime.hour + intervalHours) % 24,
          minute: selectedTime.minute,
        );
        final formattedTime = DateFormat('HH:mm a').format(
          DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute),
        );
        notifyScheduleTime.add(formattedTime);
      }
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    if(formKey2.currentState!.validate()){
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:TimeOfDay.now(),
      );

      if (picked != null) {
        var selectedTime = TimeOfDay(
          hour: picked.hour,
          minute: picked.minute,
        );

        final formattedTime = selectedTime.format(context);

        _startTimeController.text = formattedTime;

        // Calculate intake times based on selected frequencyId
        scheduleTime.clear(); // Clear the list before adding new times

        // Add the initial selected time
        scheduleTime.add(formattedTime);

        // Calculate additional times based on frequencyId
        if (frequencyId >= 1) {
          // Calculate intervals based on frequencyId
          int intervalHours = 24 ~/ frequencyId;

          for (int i = 1; i < frequencyId; i++) {
            // Add intervals to the selected time and add to the list
            selectedTime = TimeOfDay(
              hour: (selectedTime.hour + intervalHours) % 24,
              minute: selectedTime.minute,
            );
            final formattedTime = selectedTime.format(context);
            scheduleTime.add(formattedTime);
          }
        }
        setState(() {});
      }

      if (picked != null) {
        var selectedTime = TimeOfDay(
          hour: picked.hour,
          minute: picked.minute,
        );

        final formattedTime = DateFormat('HH:mm a').format(
          DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute),
        );

        // Calculate intake times based on selected frequencyId
        notifyScheduleTime.clear(); // Clear the list before adding new times

        // Add the initial selected time
        notifyScheduleTime.add(formattedTime);

        // Calculate additional times based on frequencyId
        if (frequencyId >= 1) {
          // Calculate intervals based on frequencyId
          int intervalHours = 24 ~/ frequencyId;

          for (int i = 1; i < frequencyId; i++) {
            // Add intervals to the selected time and add to the list
            selectedTime = TimeOfDay(
              hour: (selectedTime.hour + intervalHours) % 24,
              minute: selectedTime.minute,
            );
            final formattedTime = DateFormat('HH:mm a').format(
              DateTime(2023, 1, 1, selectedTime.hour, selectedTime.minute),
            );
            notifyScheduleTime.add(formattedTime);
          }
        }
        setState(() {});
      }
      print(scheduleTime);
    }
    else{
      final scaffoldMessage = ScaffoldMessenger.of(context);
      scaffoldMessage.showSnackBar(
        SnackbarUtil.showFailureSnackbar(
          message: 'Please select a frequency first',
          duration: const Duration(milliseconds: 1400),
        ),
      );
    }

  }

  Future<void> _selectStartDate(BuildContext context) async {
    if(formKey3.currentState!.validate()){

      // DateTime date = DateFormat('hh:mm a').parse(_startTimeController.text);
      DateTime now = DateTime.now();

      DateTime date = DateTime(now.year, now.month, now.day, selectedTime.hour, selectedTime.minute);


      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate:startDateIntake.isAfter(date)?startDateIntake: date.isBefore(now) ? now.add(Duration(days: 1)) :DateTime.now(),
        firstDate: date.isBefore(now) ? now.add(Duration(days: 1)) :DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 120)),
      );


      if (selectedDate != null) {
        setState(() {
          startDateIntake = selectedDate;
          endDateIntake = selectedDate.add(Duration(days: int.parse(_medicationDurationController.text)));
        });

        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateIntake);
        _startDateController.text = formattedDate;
        _endDateController.text = formattedEndDate; // Set end date to start date by default
      }
    }
    else{
      final scaffoldMessage = ScaffoldMessenger.of(context);
      scaffoldMessage.showSnackBar(
        SnackbarUtil.showFailureSnackbar(
          message: 'Please select medication duration first',
          duration: const Duration(milliseconds: 1400),
        ),
      );
    }
  }


  // void printSelectedDays() {
  //   List<String> list = [];
  //
  //   // selectedDays.clear(); // Clear the list before populating it
  //   if(isSelected != null){
  //     for (int i = 0; i < isSelected!.length; i++) {
  //
  //       if (isSelected![i]) {
  //         print(daysOfWeekMedication[i]);
  //         list.add(daysOfWeekMedication[i]);
  //
  //
  //         // selectedDays.add(daysOfWeekMedication[i]);
  //       }
  //     }
  //   }
  //
  //
  //   setState(() {
  //     days = list;
  //   });
  //   // Print the selected days
  //   // print('Selected Days: ${selectedDays.join(', ')}');
  //   print(isSelected);
  //   print(days);
  //
  //
  // }


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
                  Center(child: Text('Update Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:   ColorManager.primary,
                                    width: 2
                                )
                            )
                        ),
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child:  Center(child: Text('Step 1',style: getMediumStyle(color: page == 0?ColorManager.primary: ColorManager.black.withOpacity(0.4),fontSize: 20),)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color:page == 1?  ColorManager.primary :ColorManager.black.withOpacity(0.2),
                                    width: 2
                                )
                            )
                        ),
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child:  Center(child: Text('Step 2',style: getMediumStyle(color: page == 1? ColorManager.primary: ColorManager.black.withOpacity(0.4),fontSize: 20),)),
                      ),
                    ),

                  ],
                ),
                h20,
                Container(
                  height: 700.h,
                  child: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(), // Disable swiping between pages
                    children: [
                      _form1(_pageController),
                      _form2(_pageController)

                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _form1(PageController _pageController){
    final routes = ref.watch(routeProvider);
    final units =ref.watch(unitProvider);
    final frequencies =ref.watch(frequencyProvider);

    return Form(
      key: formKey1,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            h10,
            routes.when(
                data: (data){
                  return DropdownSearch<String>(
                    selectedItem: selectedMedTypeName,
                    items: data.map((e) => e.name).toList(),
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  ColorManager.accentGreen.withOpacity(0.5)
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  ColorManager.accentGreen.withOpacity(0.5)
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder:  OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:  ColorManager.primary
                              ),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          labelText: "Routes",
                          labelStyle: getRegularStyle(color: ColorManager.primary)
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        selectedMedTypeName = value!;
                      });
                      final selected = data.firstWhereOrNull((element) => element.name.contains(value!));
                      if(selected != null){
                        setState(() {
                          selectedMedTypeId = selected.id;

                        });
                      }
                      else if(selected == null){
                        setState(() {
                          selectedMedTypeId = 0;

                        });
                      }
                      else{
                        setState(() {
                          selectedMedTypeId = -1;
                        });
                      }

                    },
                    validator: (value){
                      if(selectedMedTypeId == 0){
                        return 'Select a route';
                      }
                      return null;
                    },
                    autoValidateMode: AutovalidateMode.onUserInteraction,


                    // selectedItem: selectedDepartment,
                    popupProps: const PopupProps<String>.menu(

                      showSearchBox: true,
                      fit: FlexFit.loose,
                      constraints: BoxConstraints(maxHeight: 350),
                      showSelectedItems: true,
                      searchFieldProps: TextFieldProps(
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                },
                error: (error,stack)=>Text('Something went wrong. Try again later'),
                loading: () => SpinKitDualRing(color: ColorManager.primary)
            ),
            h10,
            TextFormField(
              controller: _medicineNameController,
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
                labelText: 'Medicine Name',
                labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

              ),
              validator: (value){
                if(value!.trim().isEmpty){
                  return 'Name is required';
                }
                if(RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)){
                  return 'Invalid Name';
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
                    controller: _strengthController,
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
                      labelText: 'Strength',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Strength is required';
                      }
                      try{
                        final strength = double.parse(value);
                        if (strength <= 0) {
                          return 'Must be greater than 0';
                        }
                      }catch(e){
                        return 'Invalid value';
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
                units.when(
                    data: (data){
                      return Expanded(
                        child: DropdownSearch<String>(
                          selectedItem: selectedStrengthUnit,
                          items: data.map((e) => e).toList(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                enabledBorder:  OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.primary
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Units",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedStrengthUnit = value!;
                            });

                          },
                          validator: (value){
                            if(selectedStrengthUnit == null){
                              return 'Select a unit';
                            }
                            return null;
                          },
                          autoValidateMode: AutovalidateMode.onUserInteraction,


                          // selectedItem: selectedDepartment,
                          popupProps: const PopupProps<String>.menu(

                            showSearchBox: true,
                            fit: FlexFit.loose,
                            constraints: BoxConstraints(maxHeight: 350),
                            showSelectedItems: true,
                            searchFieldProps: TextFieldProps(
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    error: (error,stack)=>Text('Something went wrong. Try again later'),
                    loading: () => SpinKitDualRing(color: ColorManager.primary)
                ),
              ],
            ),
            h10,
            Form(
              key: formKey2,
              child: DropdownSearch<String>(
                selectedItem: selectedFrequencyName,
                items: frequencyType.map((e) => e.frequencyName).toList(),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  ColorManager.accentGreen.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  ColorManager.accentGreen.withOpacity(0.5)
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderSide: BorderSide(
                              color:  ColorManager.primary
                          ),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      labelText: "Frequency",
                      labelStyle: getRegularStyle(color: ColorManager.primary)
                  ),
                ),
                onChanged: (value){
                  setState(() {
                    scheduleTime.clear();
                    _startTimeController.clear();
                    selectedFrequencyName = value!;
                    frequencyId = frequencyType.firstWhere((element) => element.frequencyName == value).id;
                    intervals = value;
                  });
                  // ref.read(itemProvider.notifier).updateFrequency(selectedFrequencyName!);
                },
                validator: (value){
                  if(value == null){
                    return 'Please select a Frequency';
                  }


                  return null;
                },
                autoValidateMode: AutovalidateMode.onUserInteraction,


                // selectedItem: selectedDepartment,
                popupProps: const PopupProps<String>.menu(

                  showSearchBox: true,
                  fit: FlexFit.loose,
                  constraints: BoxConstraints(maxHeight: 350),
                  showSelectedItems: true,
                  searchFieldProps: TextFieldProps(
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),

            h10,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                        filled: true,
                        fillColor: ColorManager.dotGrey.withOpacity(0.1),

                        alignLabelWithHint: true,
                        isDense: true,
                        hintText:intervals==null? 'Intervals' : intervals,
                        hintStyle: getSemiBoldStyle(color: ColorManager.black,fontSize: 16),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.primaryDark
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 2,
                                color: ColorManager.primaryDark
                            )
                        )
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
                      isDense: true,
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
                )

              ],
            ),
            h10,
            if(scheduleTime.isNotEmpty && scheduleTime.length> 1)
              h10,
            if(scheduleTime.isNotEmpty && scheduleTime.length> 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: scheduleTime.map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
                    decoration: BoxDecoration(
                        color: ColorManager.primaryDark,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('$e',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),
                  );
                }).toList(),
              ),
            if(scheduleTime.isNotEmpty && scheduleTime.length> 1)
              h20,

            Form(
              key: formKey3,
              child: TextFormField(
                controller: _medicationDurationController,
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
                  labelText: 'Medication Duration (in days)',
                  labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                ),
                validator: (value){
                  if(value!.isEmpty){
                    return 'Duration is required';
                  }
                  if (!value.contains(RegExp(r'^\d+$'))) {
                    return 'Invalid value';
                  }
                  else if (int.parse(value) <= 0 ) {
                    return 'Must be greater than 0';
                  }
                  else if (int.parse(value) > 120 ) {
                    return 'Must be less than 120 days or 4 months';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value){
                  if(value == ''){
                    setState(() {
                      _endDateController.text = '';
                    });
                  }
                  if(_startDateController.text.isNotEmpty){
                    setState(() {
                      endDateIntake = DateTime.parse(_startDateController.text).add(Duration(days: int.parse(value)));
                      _endDateController.text= DateFormat('yyyy-MM-dd').format(endDateIntake);
                    });
                  }
                },
              ),
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
                  child: AbsorbPointer(
                    child: TextFormField(
                      controller: _endDateController,
                      readOnly: true,
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
                        labelText: 'End Date',
                        labelStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            h20,
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
                      onPressed: (){


                        formKey1.currentState!.validate();
                        formKey2.currentState!.validate();
                        formKey3.currentState!.validate();

                        if(formKey1.currentState!.validate() && formKey2.currentState!.validate() && formKey3.currentState!.validate()){
                          print('success');
                          setState(() {
                            page = 1;
                          });
                          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                        }
                        else{
                          print('Unsuccessful');
                        }
                      }, child: Text('Next',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                ),
              ],
            ),
            h100,




          ],
        ),
      ),
    );
  }


  Widget _form2(PageController _pageController){
    final selectImage = ref.watch(imageProvider);

    return Form(
      key: formKey4,
      child: SingleChildScrollView(
        child: Column(
          children: [
            h10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedMealId = 1;
                          selectedMealName = 'Before a Meal';
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorManager.dotGrey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: selectedMealId == 1 ?ColorManager.primaryDark.withOpacity(0.7):ColorManager.black.withOpacity(0.5)
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 10,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: selectedMealId == 1 ? ColorManager.orange :Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorManager.black.withOpacity(0.5)
                                    )
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                                  child: Image.asset(selectedMealId == 1 ?'assets/icons/meal.png':'assets/icons/meal2.png',width: 50,height: 50,)),

                            ],
                          )
                      ),
                    ),
                    h10,
                    Text('Before a Meal',style: getRegularStyle(color: ColorManager.black,fontSize: 12),)
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          selectedMealId =2 ;
                          selectedMealName = 'After a Meal';
                        });
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              color: ColorManager.dotGrey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color:  selectedMealId == 2 ? ColorManager.primaryDark.withOpacity(0.7): ColorManager.black.withOpacity(0.5)
                              )
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                                  child: Image.asset(selectedMealId == 2 ?'assets/icons/meal.png':'assets/icons/meal2.png',width: 50,height: 50,)),
                              Container(
                                width: 10,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: selectedMealId == 2 ? ColorManager.orange : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: ColorManager.black.withOpacity(0.5)
                                    )
                                ),
                              ),


                            ],
                          )
                      ),
                    ),
                    h10,
                    Text('After a Meal',style: getRegularStyle(color: ColorManager.black,fontSize: 12),)
                  ],
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

              items: patternList
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
                  selectedPatternId = patternList.firstWhere((element) => element.patternName == value).id;
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
            h10,
            if(selectedPatternId == 3)
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

            if(selectedPatternId == 3)
              h10,

            if(selectedPatternId == 2)
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



            if(selectedPatternId == 2)
              h10,


            if(imageSet ==1 )
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager.white,
                    border: Border.all(
                      color: ColorManager.black.withOpacity(0.5)
                    )
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.memory(updatedReminder.reminderImage!,width: 200,height: 100,),
                            // h10,
                            // Text('${selectImage.path}',style: getRegularStyle(color: ColorManager.black,fontSize: 14),overflow: TextOverflow.fade,maxLines: 1,)
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              imageSet = 2;
                            });
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorManager.textGrey.withOpacity(0.15)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                              child: FaIcon(Icons.close)),
                        ),
                      )
                    ],
                  ),
                ),
              ),

            if(imageSet == 2)

              Center(
                child:selectImage != null
                    ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: ColorManager.primary.withOpacity(0.5),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 18.h,horizontal: 12.w),
                  child: Stack(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Image.file(File(selectImage.path),width: 200,height: 100,),
                            // h10,
                            // Text('${selectImage.path}',style: getRegularStyle(color: ColorManager.black,fontSize: 14),overflow: TextOverflow.fade,maxLines: 1,)
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: ()=>ref.invalidate(imageProvider),
                          child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: ColorManager.textGrey.withOpacity(0.15)
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                              child: FaIcon(Icons.close)),
                        ),
                      )
                    ],
                  ),
                )
                    :  DottedBorder(
                  dashPattern: [16,6,16,4],
                  color:ColorManager.textGrey,
                  radius: Radius.circular(20),
                  borderType: BorderType.RRect,
                  child: InkWell(
                    onTap: () async {
                      await showModalBottomSheet(

                          backgroundColor: ColorManager.white,
                          context: context,
                          builder: (context){
                            return Container(
                              height: 150,
                              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap : (){
                                          ref.read(imageProvider.notifier).camera();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ColorManager.black.withOpacity(0.5)
                                              )
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                          child: Icon(FontAwesomeIcons.camera,color: ColorManager.black,),
                                        ),
                                      ),
                                      h10,
                                      Text('Camera',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap:(){
                                          ref.read(imageProvider.notifier).pickAnImage();
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(
                                                  color: ColorManager.black.withOpacity(0.5)
                                              )
                                          ),
                                          padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                          child: Icon(FontAwesomeIcons.image,color: ColorManager.black,),
                                        ),
                                      ),
                                      h10,
                                      Text('Gallery',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: ColorManager.textGrey.withOpacity(0.1),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 18.h),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.image,color: ColorManager.textGrey,),
                            h10,
                            Text('Please provide a image',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 20.sp),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),


            h20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _summaryController,
                    readOnly: true,
                    maxLines: null,
                    decoration: InputDecoration(
                       focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      fillColor: ColorManager.dotGrey.withOpacity(0.4),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black,
                              width: 2
                          )
                      ),
                      enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black,
                              width: 2
                          )
                      ),
                      labelText: 'Summary',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                    ),
                  ),
                ),
                w10,
                Expanded(
                  child: TextFormField(

                    maxLines: null,
                    controller: _noteController,
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
                      labelText: 'Note (optional)',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      hintText: 'E.G. Take Medicine with water',
                      hintStyle: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 16),

                    ),

                  ),
                ),
              ],
            ),

            h20,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorManager.black.withOpacity(0.7)
                      ),
                      onPressed: (){
                        setState(() {
                          page = 0;
                        });
                        _pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      }, child: Text('Back',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                ),
                w10,
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryDark
                      ),
                      onPressed:isPostingData? null : () async {
                        Uint8List? reminderImage;
                        List<String> list = [];

                        // selectedDays.clear(); // Clear the list before populating it
                        if(formKey4.currentState!.validate()){
                          setState(() {
                            isPostingData = true;
                          });
                            await NotificationController.cancelNotifications(id: contentId);
                            await NotificationController.cancelNotifications(id: initialContentId);



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

                          if(selectImage != null) {

                            reminderImage = await selectImage.readAsBytes();

                          }




                          /// FOR EVERYDAY....
                          if(selectedPatternId == 1){
                            final int totalDays = int.parse(_medicationDurationController.text.trim());
                            final int totalInterval = scheduleTime.length;
                            final DateTime firstDate = DateTime(startDateIntake.year,startDateIntake.month,startDateIntake.day,DateFormat('hh:mm').parse(notifyScheduleTime[0]).hour,DateFormat('hh:mm').parse(notifyScheduleTime[0]).minute);
                            final DateTime initialDate = firstDate.subtract(Duration(minutes: 10));



                            List<DateListModel> scheduleList = [];


                            for(int i = 0 ; i<totalDays; i++){
                              DateTime newDate = firstDate.add(Duration(days: i));
                              print(newDate);
                              for(int j = 0 ; j < totalInterval ; j++){

                                int dateId = j + 1;
                                DateTime notificationDates = DateTime(newDate.year,newDate.month,newDate.day,DateFormat('hh:mm').parse(notifyScheduleTime[j]).hour,DateFormat('hh:mm').parse(notifyScheduleTime[j]).minute);
                                DateListModel addDates = DateListModel(dateId: dateId, reminderDate: notificationDates);

                                scheduleList.add(addDates);
                              }
                            }

                            print('scheduled list : ${scheduleList.length}');

                            int contentId = Random().nextInt(9999);
                            int initialContentId = Random().nextInt(9999);

                            final NotificationContent content = NotificationContent(
                              id: contentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '${_strengthController.text} ${selectedStrengthUnit} ${selectedMealName}',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              category: NotificationCategory.Alarm,
                              wakeUpScreen: true,
                              timeoutAfter: Duration(minutes: 1),


                              displayOnForeground: true,
                              displayOnBackground: true,
                              backgroundColor: Colors.black,
                              // customSound: 'resource://raw/notif',
                              payload: {
                                'reminderTypeId' : '1',
                                'dateId': '1'
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


                            final NotificationContent initialContent = NotificationContent(
                              id: initialContentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '10 minutes before your medicine',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              displayOnBackground: true,
                              backgroundColor: Colors.black,

                            );
                            final NotificationCalendar initialSchedule = NotificationCalendar.fromDate(date: initialDate);


                            await NotificationController.scheduleNotifications(schedule: schedule, content: content);
                            await NotificationController.scheduleInitialNotifications(schedule: initialSchedule, content: initialContent);



                            Reminder reminder = Reminder(
                                reminderTypeId: 1,
                                reminderId: widget.reminderTest.reminderId,
                                userId: widget.reminderTest.userId,
                                medTypeId: selectedMedTypeId,
                                medTypeName: selectedMedTypeName,
                                medicineName: _medicineNameController.text.trim(),
                                strength: int.parse(_strengthController.text),
                                unit: selectedStrengthUnit!,
                                frequency: Frequency(
                                    frequencyId: frequencyId,
                                    frequencyName: selectedFrequencyName,
                                    intervals: intervals
                                ) ,
                                scheduleTime: scheduleTime,
                                medicationDuration: int.parse(_medicationDurationController.text.trim()),
                                startDate: startDateIntake,
                                endDate: endDateIntake,
                                mealTypeId: selectedMealId,
                                meal: selectedMealName,
                                reminderPattern:ReminderPattern(
                                    reminderPatternId: selectedPatternId,
                                    patternName: selectedPatternName,
                                    interval: selectedPatternId == 3 ? int.parse(_intervalDurationController.text) : null,
                                    daysOfWeek: selectedPatternId == 2 ? days : null
                                ) ,
                                reminderImage: selectImage != null ? reminderImage : null,
                                notes: _noteController.text.isEmpty? null : _noteController.text.trim(),
                                summary: _summaryController.text.trim(),
                                contentId: contentId,
                                initialContentId: initialContentId,
                                dateList: scheduleList
                            );

                            _updateReminder(reminder);



                          }


                          /// FOR Specific days....
                          if(selectedPatternId == 2){
                            final int totalDays = int.parse(_medicationDurationController.text.trim());
                            final int totalInterval = scheduleTime.length;
                            final DateTime firstDate = DateTime(
                              startDateIntake.year,
                              startDateIntake.month,
                              startDateIntake.day,
                              DateFormat('hh:mm').parse(notifyScheduleTime[0]).hour,
                              DateFormat('hh:mm').parse(notifyScheduleTime[0]).minute,
                            );
                            final DateTime initialDate = firstDate.subtract(Duration(minutes: 10));

                            List<DateListModel> scheduleList = [];


                            int addedDatesCount = 0;

                            do {
                              DateTime newDate = firstDate.add(Duration(days: addedDatesCount));



                              for (int j = 0; j < totalInterval; j++) {
                                int index = 0;
                                DateTime notificationDates = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  int.parse(scheduleTime[j].split(':').first),
                                  int.parse(scheduleTime[j].split(':').last.split(' ').first),
                                );

                                print(notificationDates);

                                if (days!.contains(DateFormat('EEEE').format(notificationDates))) {
                                  index++;
                                  int dateId = index;
                                  DateListModel dateList = DateListModel(dateId: dateId, reminderDate: notificationDates);
                                  scheduleList.add(dateList);
                                }
                              }

                              addedDatesCount++;

                            } while (scheduleList.length < totalDays * totalInterval);

                            print(scheduleList.length);

                            int contentId = Random().nextInt(9999);
                            int initialContentId = Random().nextInt(9999);


                            final NotificationContent content = NotificationContent(
                              id: contentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '${_strengthController.text} ${selectedStrengthUnit} ${selectedMealName}',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              category: NotificationCategory.Alarm,
                              wakeUpScreen: true,
                              timeoutAfter: Duration(minutes: 1),

                              backgroundColor: Colors.black,
                              // customSound: 'resource://raw/notif',
                              payload: {
                                'reminderTypeId' : '1',
                                'dateId': '1'
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



                            await NotificationController.scheduleNotifications( schedule: schedule, content: content);

                            final NotificationContent initialContent = NotificationContent(
                              id: initialContentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '10 minutes before your medicine',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              displayOnBackground: true,
                              backgroundColor: Colors.black,

                            );
                            final NotificationCalendar initialSchedule = NotificationCalendar.fromDate(date: initialDate);


                            await NotificationController.scheduleInitialNotifications( schedule: initialSchedule, content: initialContent);

                            Reminder reminder = Reminder(
                                reminderId: widget.reminderTest.reminderId,
                                userId: widget.reminderTest.userId,
                                medTypeId: selectedMedTypeId,
                                medTypeName: selectedMedTypeName,
                                medicineName: _medicineNameController.text.trim(),
                                strength: int.parse(_strengthController.text),
                                unit: selectedStrengthUnit!,
                                frequency: Frequency(
                                    frequencyId: frequencyId,
                                    frequencyName: selectedFrequencyName,
                                    intervals: intervals
                                ) ,
                                scheduleTime: scheduleTime,
                                medicationDuration: int.parse(_medicationDurationController.text.trim()),
                                startDate: startDateIntake,
                                endDate: endDateIntake,
                                mealTypeId: selectedMealId,
                                meal: selectedMealName,
                                reminderPattern:ReminderPattern(
                                    reminderPatternId: selectedPatternId,
                                    patternName: selectedPatternName,
                                    interval: selectedPatternId == 3 ? int.parse(_intervalDurationController.text) : null,
                                    daysOfWeek: selectedPatternId == 2 ? days : null
                                ) ,
                                reminderImage: selectImage != null ? reminderImage : null,
                                notes: _noteController.text.isEmpty? null : _noteController.text.trim(),
                                summary: _summaryController.text.trim(),
                                contentId: contentId,
                                initialContentId: initialContentId,
                                reminderTypeId: 1,
                                dateList: scheduleList
                            );

                            _updateReminder(reminder);
                          }


                          /// FOR INTERVALS....
                          if(selectedPatternId == 3){
                            final int totalDays = int.parse(_medicationDurationController.text.trim());
                            final int totalInterval = scheduleTime.length;
                            final DateTime firstDate = DateTime(startDateIntake.year,startDateIntake.month,startDateIntake.day,DateFormat('hh:mm').parse(notifyScheduleTime[0]).hour,DateFormat('hh:mm').parse(notifyScheduleTime[0]).minute);
                            final DateTime initialDate = firstDate.subtract(Duration(minutes: 10));
                            List<DateListModel> scheduleList = [];


                            for(int i = 0 ; i<totalDays; i++){
                              DateTime newDate = firstDate.add(Duration(days: i == 0 ? 0 :int.parse(_intervalDurationController.text) ));
                              for(int j = 0 ; j < totalInterval ; j++){
                                int dateId = j+1;
                                DateTime notificationDates = DateTime(newDate.year,newDate.month,newDate.day,DateFormat('hh:mm').parse(notifyScheduleTime[j]).hour,DateFormat('hh:mm').parse(notifyScheduleTime[j]).minute);

                                DateListModel dateList = DateListModel(dateId: dateId, reminderDate: notificationDates);

                                scheduleList.add(dateList);
                              }
                            }

                            int contentId = Random().nextInt(9999);
                            int initialContentId = Random().nextInt(9999);

                            final NotificationContent content = NotificationContent(
                              id: contentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '${_strengthController.text} ${selectedStrengthUnit} ${selectedMealName}',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              category: NotificationCategory.Alarm,
                              wakeUpScreen: true,
                              timeoutAfter: Duration(minutes: 1),

                              //
                              backgroundColor: Colors.black,
                              // customSound: 'resource://raw/notif',
                              payload: {'actPag': 'myAct', 'actType': 'medicine'},
                            );

                            final NotificationCalendar schedule = NotificationCalendar(
                                year: firstDate.year,
                                month: firstDate.month,
                                day: firstDate.day,
                                hour: firstDate.hour,
                                minute: firstDate.minute,
                                timeZone: await AwesomeNotifications().getLocalTimeZoneIdentifier()
                              );



                            await NotificationController.scheduleNotifications(schedule: schedule, content: content);
                            final NotificationContent initialContent = NotificationContent(
                              id: initialContentId,
                              channelKey: 'alerts',
                              title: _medicineNameController.text.trim(),
                              body: '10 minutes before your medicine',
                              notificationLayout: NotificationLayout.Default,
                              //actionType : ActionType.DisabledAction,
                              color: Colors.black,
                              wakeUpScreen: true,
                              displayOnForeground: true,
                              displayOnBackground: true,
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


                            await NotificationController.scheduleInitialNotifications( schedule: initialSchedule, content: initialContent);


                            Reminder reminder = Reminder(
                                reminderId: widget.reminderTest.reminderId,
                                userId: widget.reminderTest.userId,
                                medTypeId: selectedMedTypeId,
                                medTypeName: selectedMedTypeName,
                                medicineName: _medicineNameController.text.trim(),
                                strength: int.parse(_strengthController.text),
                                unit: selectedStrengthUnit!,
                                frequency: Frequency(
                                    frequencyId: frequencyId,
                                    frequencyName: selectedFrequencyName,
                                    intervals: intervals
                                ) ,
                                scheduleTime: scheduleTime,
                                medicationDuration: int.parse(_medicationDurationController.text.trim()),
                                startDate: startDateIntake,
                                endDate: endDateIntake,
                                mealTypeId: selectedMealId,
                                meal: selectedMealName,
                                reminderPattern:ReminderPattern(
                                    reminderPatternId: selectedPatternId,
                                    patternName: selectedPatternName,
                                    interval: selectedPatternId == 3 ? int.parse(_intervalDurationController.text) : null,
                                    daysOfWeek: selectedPatternId == 2 ? days : null
                                ) ,
                                reminderImage: selectImage != null ? reminderImage : null,
                                notes: _noteController.text.isEmpty? null : _noteController.text.trim(),
                                summary: _summaryController.text.trim(),
                                contentId: contentId,
                                initialContentId: initialContentId,
                                reminderTypeId: 1,
                                dateList: scheduleList
                            );

                            _updateReminder(reminder);
                          }


                        }





                      }, child: Text('Save',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


}


