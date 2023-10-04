




import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_db.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../common/snackbar.dart';

class CreateReminder extends ConsumerStatefulWidget {
  const CreateReminder({super.key});

  @override
  ConsumerState<CreateReminder> createState() => _CreateReminderState();
}

class _CreateReminderState extends ConsumerState<CreateReminder> with TickerProviderStateMixin {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _strengthController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _totalDaysController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _intervalDurationController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  TextEditingController _summaryController = TextEditingController();
  int selectedMedicineType = 1;
  String selectedMedicineTypeName = '';
  String selectedStrengthUnit = '';
  String selectedFrequency = 'Select a frequency';

  int frequency = 0;
  String? intervals;
  List<TimeOfDay> intakeSchedule = [];
  DateTime? endDateIntake;

  int imageSet = 1;


  List<bool> isSelected = [false, false, false, false, false, false, false];


  Future<void> _selectTime(BuildContext context) async {
    if(formKey2.currentState!.validate()){
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (picked != null) {
        var selectedTime = TimeOfDay(
          hour: picked.hour,
          minute: picked.minute,
        );

        final formattedTime = selectedTime.format(context);

        _startTimeController.text = formattedTime;

        // Calculate intake times based on selected frequency
        intakeSchedule.clear(); // Clear the list before adding new times

        // Add the initial selected time
        intakeSchedule.add(selectedTime);

        // Calculate additional times based on frequency
        if (frequency >= 1) {
          // Calculate intervals based on frequency
          int intervalHours = 24 ~/ frequency;

          for (int i = 1; i < frequency; i++) {
            // Add intervals to the selected time and add to the list
            selectedTime = TimeOfDay(
              hour: (selectedTime.hour + intervalHours) % 24,
              minute: selectedTime.minute,
            );
            intakeSchedule.add(selectedTime);
          }
        }
        setState(() {});
      }
      print(intakeSchedule);
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
      final DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );


      if (selectedDate != null) {
        setState(() {
          endDateIntake = selectedDate.add(Duration(days: int.parse(_totalDaysController.text)));
        });

        final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
        final formattedEndDate = DateFormat('yyyy-MM-dd').format(endDateIntake!);
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


  void printSelectedDays() {
    final selectedDays = <String>[];
    for (int i = 0; i < isSelected.length; i++) {
      if (isSelected[i]) {
        selectedDays.add(daysOfWeekMedication[i]);
      }
    }
    print('Selected Days: ${selectedDays.join(', ')}');
  }





  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 2, vsync: this);
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
                          child: ZoomIn(
                              duration: Duration(seconds: 1),
                              child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.3),size: 70,)))
                  ),
                  Positioned(
                    top: 20,
                      left: 50,
                      child: Transform.rotate(
                          angle: 30 * 3.14159265358979323846 / 180,
                          child: ZoomIn(
                              duration: Duration(seconds: 1),
                              child: FaIcon(FontAwesomeIcons.heartPulse,color: ColorManager.white.withOpacity(0.3),size: 80,)))
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () => Get.back(),
                      child: FaIcon(Icons.chevron_left, color: ColorManager.white,size: 30,
                      ),
                    ),
                  ),
                  Center(child: Text('Create a Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
                ],
              )),
          
        ),
        body: SlideInUp(
          duration: Duration(seconds: 1),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30)
              ),
              color: ColorManager.white,
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(

                  height: 70,
                  child: TabBar(
                    dividerColor: ColorManager.dotGrey,


                      controller: _tabController,
                      padding: EdgeInsets.symmetric(
                          vertical: 8.h, horizontal: 8.w),
                      labelStyle: getMediumStyle(
                          color: ColorManager.black,
                          fontSize: 18
                      ),
                      onTap: (index){
                        _tabController.index = 0;
                      },
                      unselectedLabelStyle: getMediumStyle(
                          color: ColorManager.textGrey,
                          fontSize: 18
                      ),
                      isScrollable: false,
                      labelPadding: EdgeInsets.only(left: 15.w, right: 15.w),
                      labelColor: ColorManager.primaryDark,

                      unselectedLabelColor: ColorManager.textGrey,
                      // indicatorColor: primary,
                      indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: ColorManager.primaryDark
                          )),
                      // dividerColor: ColorManager.primaryDark,

                      tabs: [
                        Tab(
                          text: 'Step 1',
                        ),
                        Tab(text: 'Step 2'),
                      ]),
                ),
                Expanded(
                  child: TabBarView(

                      controller: _tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _form1(_tabController),
                        _form2(_tabController),



                      ]
                  ),
                )


              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _form1(TabController _tabController){
    return Form(
      key: formKey1,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            h10,
            Container(
              // color: ColorManager.red,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: medicineType.map((e){
                  return InkWell(
                    splashColor: MaterialStateColor.resolveWith((states) => Colors.transparent),
                    onTap: (){
                      setState(() {
                        selectedMedicineType =e.id;
                        selectedMedicineTypeName = e.name;

                      });

                    },
                    child: Container(

                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: selectedMedicineType ==e.id? ColorManager.blueText.withOpacity(0.3):ColorManager.dotGrey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color:  selectedMedicineType ==e.id? ColorManager.blueText:ColorManager.dotGrey
                                  )
                              ),
                              padding:EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                              child: FaIcon(e.icon,color:selectedMedicineType ==e.id? ColorManager.blueText.withOpacity(0.8):ColorManager.black.withOpacity(0.4),)),
                          h10,
                          Text(e.name,style: getRegularStyle(color: selectedMedicineType ==e.id? ColorManager.blueText.withOpacity(0.8):ColorManager.dotGrey,fontSize: 12),)
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            h20,
            TextFormField(
              controller: _medicineNameController,
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
                labelText: 'Medicine Name',
                labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

              ),
              validator: (value){
                if(value!.isEmpty){
                  return 'Name is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,

            ),
            h10,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _strengthController,
                    keyboardType: TextInputType.phone,
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
                      labelText: 'Strength',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Strength is required';
                      }
                      if (!value.contains(RegExp(r'^\d+$'))) {
                        return 'Invalid value';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                w10,
                Expanded(
                  child: DropdownButtonFormField(
                      menuMaxHeight: 200,
                      isDense: true,
                      value:strengthType.where((element) => element.typeId == selectedMedicineType).first.unitName,
                      decoration: InputDecoration(

                          isDense: true,
                          labelText: 'Unit',
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

                      items: strengthType.where((element) => element.typeId == selectedMedicineType)
                          .map(
                            (StrengthModel item) => DropdownMenuItem<String>(
                          value: item.unitName,
                          child: Text(
                            item.unitName,
                            style: getRegularStyle(color: Colors.black,fontSize: 16.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ).toList(),
                      onChanged: (value){
                        setState(() {
                          selectedStrengthUnit = value!;
                        });
                      }
                  ),
                )
              ],
            ),
            h10,
            Form(
              key: formKey2,
              child: DropdownButtonFormField(

                menuMaxHeight: 250,
                isDense: true,
                value: selectedFrequency,
                decoration: InputDecoration(

                    isDense: true,
                    labelText: 'Frequency',
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

                items: frequencyType
                    .map(
                      (FrequencyModel item) => DropdownMenuItem<String>(
                    value: item.frequencyName,
                    child: Text(
                      item.frequencyName,
                      style: getRegularStyle(color: Colors.black,fontSize: 16.sp),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ).toList(),
                onChanged: (value){
                  setState(() {
                    intakeSchedule.clear();
                    _startTimeController.clear();
                    selectedFrequency = value!;
                    frequency = frequencyType.firstWhere((element) => element.frequencyName == value).id;
                    intervals = frequencyType.firstWhere((element) => element.frequencyName == value).frequencyInterval;
                  });
                  print(selectedFrequency);
                },
                validator: (value){
                  if(selectedFrequency == 'Select a frequency'){
                    return 'Frequency is required';
                  }

                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      suffixIconConstraints: BoxConstraints.tightForFinite(),
                      suffixIcon: Padding(
                        padding: EdgeInsets.only(right: 18.w),
                        child: FaIcon(
                          Icons.access_time,
                          color: ColorManager.blueText,
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
                        return 'Time is required';
                      }


                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                )

              ],
            ),
            if(intakeSchedule.isNotEmpty && intakeSchedule.length> 1)
              h10,
            if(intakeSchedule.isNotEmpty && intakeSchedule.length> 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: intakeSchedule.map((e) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 8.w),
                    decoration: BoxDecoration(
                        color: ColorManager.primaryDark,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text('${e.hour}:${e.minute} ${e.period.name}',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),
                  );
                }).toList(),
              ),
            if(intakeSchedule.isNotEmpty && intakeSchedule.length> 1)
              h10,
            h10,
            Form(
              key: formKey3,
              child: TextFormField(
                controller: _totalDaysController,
                keyboardType: TextInputType.phone,
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
                      _endDateController.text= DateFormat('yyyy-MM-dd').format(endDateIntake!);
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.blueText)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.primaryDark)),
                          labelText: 'Start Date',
                          labelStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Start date is required';
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
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.blueText)),
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
                          _tabController.index = 1;
                        }
                        else{
                          print('Unsucessful');
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


  Widget _form2(TabController _tabController){
    final selectImage = ref.watch(imageProvider);
    final selectMealType = ref.watch(itemProvider).selectMealType;
    final selectedPattern = ref.watch(itemProvider).selectedPattern;
    final selectedPatternId = ref.watch(itemProvider).selectPatternId;
    return Form(
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
                        ref.read(itemProvider.notifier).updateMealType(1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.dotGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectMealType == 1 ?ColorManager.primaryDark.withOpacity(0.7):ColorManager.black.withOpacity(0.5)
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
                                color: selectMealType == 1 ? ColorManager.orange :Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: ColorManager.black.withOpacity(0.5)
                                )
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                                child: Image.asset(selectMealType == 1 ?'assets/icons/meal.png':'assets/icons/meal2.png',width: 50,height: 50,)),

                          ],
                        )
                      ),
                    ),
                    h10,
                    Text('Before Meal',style: getRegularStyle(color: ColorManager.black,fontSize: 12),)
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: (){
                        ref.read(itemProvider.notifier).updateMealType(2);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorManager.dotGrey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color:  selectMealType == 2 ? ColorManager.primaryDark.withOpacity(0.7): ColorManager.black.withOpacity(0.5)
                          )
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                                child: Image.asset(selectMealType == 2 ?'assets/icons/meal.png':'assets/icons/meal2.png',width: 50,height: 50,)),
                            Container(
                              width: 10,
                              height: 30,
                              decoration: BoxDecoration(
                                color: selectMealType == 2 ? ColorManager.orange : Colors.transparent,
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
                    Text('After Meal',style: getRegularStyle(color: ColorManager.black,fontSize: 12),)
                  ],
                ),

              ],
            ),
            h20,
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
              value: selectedPattern,

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

                 ref.read(itemProvider.notifier).updatePattern(value!);
                 ref.read(itemProvider.notifier).updatePatternId(patternList.firstWhere((element) => element.patternName == value).id);
                 print(selectedPatternId);
              },
              validator: (value){
                if(selectedPattern == ''||selectedPattern =='Select a pattern'){
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
                keyboardType: TextInputType.phone,
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
                        isSelected[index] = !isSelected[index];
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: isSelected[index]
                            ? ColorManager.primaryDark
                            : ColorManager.dotGrey.withOpacity(0.5), // Selected and unselected colors
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Text(
                        '${day.substring(0, 3)}',
                        style: TextStyle(
                          color: isSelected[index]
                              ? ColorManager.white
                              : Colors.black, // Text color when selected and unselected
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

            if(selectedPatternId == 2)
              h10,

            Center(
              child:selectImage != null
                  ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorManager.blueText.withOpacity(0.5),
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
                color:imageSet == 2 ? ColorManager.red: ColorManager.textGrey,
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
                      labelText: 'Note (optional)',
                      labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      hintText: 'E.G. Take Medicine with water',
                      hintStyle: getRegularStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 16),

                    ),
                    validator: (value){
                      if(value!.isEmpty){
                        return 'Interval is required';
                      }
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
                      onPressed: (){
                        _tabController.index = 0;
                      }, child: Text('Back',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)),
                ),
                w10,
                Expanded(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryDark
                      ),
                      onPressed: (){
                        printSelectedDays();
                        // formKey1.currentState!.validate();
                        // formKey2.currentState!.validate();
                        // formKey3.currentState!.validate();
                        //
                        // if(formKey1.currentState!.validate() && formKey2.currentState!.validate() && formKey3.currentState!.validate()){
                        //   print('success');
                        //   _tabController.index = 1;
                        // }
                        // else{
                        //   print('Unsucessful');
                        // }
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
