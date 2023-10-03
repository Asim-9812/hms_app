




import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/patient/reminders/data/reminder_db.dart';

import '../../../../core/resources/value_manager.dart';

class CreateReminder extends StatefulWidget {
  const CreateReminder({super.key});

  @override
  State<CreateReminder> createState() => _CreateReminderState();
}

class _CreateReminderState extends State<CreateReminder> {
  TextEditingController _medicineNameController = TextEditingController();
  TextEditingController _strengthController = TextEditingController();
  TextEditingController _totalDaysController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _reminderDurationDateController = TextEditingController();
  TextEditingController _breakDurationController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  int selectIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                        selectIndex =e.id;
                      });
                    },
                    child: Container(

                      child: Column(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  color: selectIndex ==e.id? ColorManager.blueText.withOpacity(0.3):ColorManager.dotGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10)
                              ),
                              padding:EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
                              child: FaIcon(e.icon,color:selectIndex ==e.id? ColorManager.blueText.withOpacity(0.8):ColorManager.black.withOpacity(0.4),)),
                          h10,
                          Text(e.name,style: getRegularStyle(color: selectIndex ==e.id? ColorManager.blueText.withOpacity(0.8):ColorManager.dotGrey.withOpacity(0.8),fontSize: 12),)
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
            )

          ],
        ),
      ),
    );
  }
}
