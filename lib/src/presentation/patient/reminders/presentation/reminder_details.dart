



import 'package:animate_do/animate_do.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/presentation/organization/organization_dashboard/presentation/org_homepage.dart';
import 'package:medical_app/src/presentation/patient/reminders/domain/model/reminder_model.dart';
import 'package:medical_app/src/presentation/patient/reminders/widgets/update_reminder.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../data/reminder_db.dart';

class ReminderIndividual extends StatefulWidget {
  final ReminderModel reminderModel;
  ReminderIndividual({required this.reminderModel});

  @override
  State<ReminderIndividual> createState() => _ReminderIndividualState();
}

class _ReminderIndividualState extends State<ReminderIndividual> {
  final _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _noteController.text = widget.reminderModel.reminderNote == null ? '' : widget.reminderModel.reminderNote!;
    final currentTime = DateTime.now();
    final remainingDays = widget.reminderModel.endDate.difference(currentTime);
    return Scaffold(
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
                        child: FaIcon(CupertinoIcons.alarm,color: ColorManager.white.withOpacity(0.3),size: 70,))
                ),
                Positioned(
                    top: 20,
                    left: 50,
                    child: Transform.rotate(
                        angle: 30 * 3.14159265358979323846 / 180,
                        child: FaIcon(FontAwesomeIcons.notesMedical,color: ColorManager.white.withOpacity(0.3),size: 80,))
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: () => Get.back(),
                    child: FaIcon(Icons.chevron_left, color: ColorManager.white,size: 30,
                    ),
                  ),
                ),
                Center(child: Text('Reminder',style: getHeadBoldStyle(color: ColorManager.white),)),
              ],
            )),

      ),
      body: Container(
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))
        ),
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Column(
          children: [
            h20,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: ColorManager.primaryDark,
                  child: FaIcon(medicineType.firstWhere((element) => element.id == widget.reminderModel.medicineType).icon,color: ColorManager.white.withOpacity(0.5),size: 30,),
                ),
                w20,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${widget.reminderModel.medicineName}',style: getSemiBoldStyle(color: ColorManager.black,fontSize: 32),),
                    h10,
                    Row(
                      children: widget.reminderModel.intakeTime.map((e){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                          margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorManager.primaryDark.withOpacity(0.7)
                          ),
                          child: Text('$e',style: getRegularStyle(color: ColorManager.white,fontSize: 12),),
                        );
                      }).toList(),
                    )
                  ],
                )

              ],
            ),
            h20,
            Container(
              decoration: BoxDecoration(
                color: ColorManager.primaryDark,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text('Dose:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                          w10,
                          Text('${widget.reminderModel.strength} ${widget.reminderModel.strengthUnitType}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                        ],
                      ),
                      Text('${widget.reminderModel.medicineTime}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)


                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Frequency:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                      w10,
                      Text('${widget.reminderModel.frequency}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Duration:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                      w10,
                      Text('${widget.reminderModel.totalDays} days',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Consumption Pattern:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                      w10,
                      widget.reminderModel.breakDuration != 0 ? Text('Every ${widget.reminderModel.breakDuration} days',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)
                          : widget.reminderModel.daysOfWeek == null ?   Text('Everyday',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)
                          : Row(
                        children: widget.reminderModel.daysOfWeek!.map((e){
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
                            margin: EdgeInsets.only(right: 5.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorManager.white.withOpacity(0.7)
                            ),
                            child: Text('${e.substring(0,3)}',style: getRegularStyle(color: ColorManager.primaryDark,fontSize: 12),),
                          );
                        }).toList(),
                      )
                    ],
                  ),


                ],
              ),
            ),

            h20,
            Container(
              decoration: BoxDecoration(
                color: ColorManager.primaryDark,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Start Date',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                          h10,
                          Text('${DateFormat('yyyy-MM-dd').format(widget.reminderModel.startDate)}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                        ],
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('End Date',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                          h10,
                          Text('${DateFormat('yyyy-MM-dd').format(widget.reminderModel.endDate)}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                        ],
                      ),
                    ],
                  ),
                  h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Progress:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                      w10,
                      Text('${remainingDays.inDays +1} days left',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                    ],
                  ),
                  h10,
                  LinearProgressBar(
                      maxSteps: widget.reminderModel.totalDays,
                      currentStep: widget.reminderModel.totalDays - remainingDays.inDays-1,
                      progressColor: ColorManager.orange,
                      backgroundColor: ColorManager.dotGrey
                  ),
                ],
              ),
            ),
            h20,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.reminderModel.reminderImage != null)
                InkWell(
                  onTap: (){
                    final image = Image.memory(widget.reminderModel.reminderImage!).image;
                    showImageViewer(context, image, onViewerDismissed: () {
                      print("dismissed");
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)
                    ),
                      width: 100,height: 100,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(widget.reminderModel.reminderImage!,fit: BoxFit.cover,))),
                ),
                if(widget.reminderModel.reminderNote != null&&widget.reminderModel.reminderImage != null)
                w10,
                if(widget.reminderModel.reminderNote != null)
                  Expanded(
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _noteController,
                        readOnly: true,
                        maxLines: null,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ColorManager.dotGrey.withOpacity(0.2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: ColorManager.primaryDark,
                              width: 2
                            )
                          ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.primaryDark,
                                    width: 2
                                )
                            ),
                          labelText: 'Note',
                          labelStyle: getRegularStyle(color: ColorManager.primaryDark)
                        ),
                      ),
                    ),
                  )
              ],
            ),
            h20,
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.red.withOpacity(0.7),
                      elevation: 0
                    ),
                      onPressed: () async {
                       int back = 0;
                        await showDialog(
                            context: context,
                            builder: (context){
                              return AlertDialog(
                                content: Text('Do you want to delete this reminder?',style: getRegularStyle(color: ColorManager.black),),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorManager.primaryDark
                                      ),
                                      onPressed: (){
                                        widget.reminderModel.delete();
                                        setState(() {
                                          back = 1;
                                        });
                                        Navigator.pop(context);
                                      }, child: Text('Yes')),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                          backgroundColor: ColorManager.dotGrey
                                      ),
                                      onPressed: (){

                                        Navigator.pop(context);

                                      }, child: Text('No',style: TextStyle(color: ColorManager.black),)),
                                ],
                                actionsAlignment: MainAxisAlignment.center,
                              );
                            }
                        );
                        if(back == 1){
                          Get.back();
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FaIcon(Icons.delete,color: ColorManager.white,size: 16,),
                          w10,
                          Text('Delete',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                        ],
                      ) ),
                ),
                // w10,
                // Expanded(
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: ColorManager.blueText,
                //       elevation: 0
                //     ),
                //       onPressed: ()=>Get.to(()=>UpdateReminder(reminderModel)),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.end,
                //         children: [
                //           FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.white,size: 16,),
                //           w10,
                //           Text('Edit',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                //         ],
                //       ) ),
                // ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
