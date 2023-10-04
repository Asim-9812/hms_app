




import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_db.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';

class Reminders extends StatefulWidget {
  const Reminders({super.key});

  @override
  State<Reminders> createState() => _ReminderState();
}

class _ReminderState extends State<Reminders> {
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _strengthController = TextEditingController();
  TextEditingController _startTimeController = TextEditingController();
  TextEditingController _totalDaysController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TextEditingController _reminderDurationDateController = TextEditingController();
  TextEditingController _breakDurationController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  int selectedMedicineType = 1;
  String selectedStrengthUnit = '';
  String selectedFrequency = 'Select a frequency';
  int frequency = 0;
  String? intervals;
  List<TimeOfDay> intakeSchedule = [];
  DateTime? endDateIntake;



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





  @override
  Widget build(BuildContext context) {
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
                  Center(child: Text('Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
                ],
              )),

        ),
        body: Container(),

      ),
    );
  }
}
