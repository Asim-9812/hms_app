import 'dart:typed_data';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:medical_app/src/presentation/patient/reminder_test/domain/model/reminder_model.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../reminders/data/reminder_db.dart';
import 'edit_page.dart'; // for image decoding

class TestDetails extends StatefulWidget {
  final Reminder reminder;

  TestDetails(this.reminder);

  @override
  State<TestDetails> createState() => _TestDetailsState();
}

class _TestDetailsState extends State<TestDetails> {

  GlobalKey<_TestDetailsState> refreshKey = GlobalKey();



  late Box<Reminder> reminderBox;
  late ValueListenable<Box<Reminder>> reminderBoxListenable;

  int page  = 0;
  PageController _pageController = PageController(initialPage: 0);
  final _noteController = TextEditingController();




  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<Reminder>('med_reminder');

    // Create a ValueListenable for the box
    reminderBoxListenable = reminderBox.listenable();

    // Add a listener to update the UI when the box changes
    reminderBoxListenable.addListener(onHiveBoxChanged);
  }

  void onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }

  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    reminderBoxListenable.removeListener(onHiveBoxChanged);
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    // Decode the image
     img.Image? image;
    if(widget.reminder.reminderImage !=null){
      image =img.decodeImage(widget.reminder.reminderImage!);
    }

    final reminder = Hive.box<Reminder>('med_reminder');

    final int index = reminder.values.toList().indexWhere((element) => element.reminderId == widget.reminder.reminderId);

    final reminderBox = reminder.getAt(index)!;

     _noteController.text = widget.reminder.notes == null ? '' : widget.reminder.notes!;
     final currentTime = DateTime.now();
     final remainingDays = widget.reminder.endDate.difference(currentTime);




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
                   child: FaIcon(medicineType.firstWhere((element) => element.name == widget.reminder.medTypeName).icon,color: ColorManager.white.withOpacity(0.5),size: 30,),
                 ),
                 w20,
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('${widget.reminder.medicineName}',style: getSemiBoldStyle(color: ColorManager.black,fontSize: 32),),
                     h10,
                     Row(
                       children: widget.reminder.scheduleTime.map((e){
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
                           Text('${widget.reminder.strength} ${widget.reminder.unit}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ),
                       Text('${widget.reminder.meal}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)


                     ],
                   ),
                   h20,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text('Frequency:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                       w10,
                       Text('${widget.reminder.frequency.frequencyName}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                     ],
                   ),
                   h20,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text('Duration:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                       w10,
                       Text('${widget.reminder.medicationDuration} days',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                     ],
                   ),
                   h20,
                   Row(
                     mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                       Text('Consumption Pattern:',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                       w10,
                       widget.reminder.reminderPattern.interval != null ? Text('Every ${widget.reminder.reminderPattern.interval} days',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)
                           : widget.reminder.reminderPattern.daysOfWeek == null ?   Text('Everyday',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)
                           : Row(
                         children: widget.reminder.reminderPattern.daysOfWeek!.map((e){
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
                           Text('${DateFormat('yyyy-MM-dd').format(widget.reminder.startDate)}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ),

                       Column(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Text('End Date',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                           h10,
                           Text('${DateFormat('yyyy-MM-dd').format(widget.reminder.endDate)}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
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
                       maxSteps: widget.reminder.medicationDuration,
                       currentStep: widget.reminder.medicationDuration - remainingDays.inDays-1,
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
                 if(widget.reminder.reminderImage != null)
                   InkWell(
                     onTap: (){
                       final image = Image.memory(widget.reminder.reminderImage!).image;
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
                             child: Image.memory(widget.reminder.reminderImage!,fit: BoxFit.cover,))),
                   ),
                 if(widget.reminder.notes != null&&widget.reminder.reminderImage != null)
                   w10,
                 if(widget.reminder.notes != null)
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
                                         reminder.deleteAt(index);
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
                 w10,
                 Expanded(
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: ColorManager.blueText,
                       elevation: 0
                     ),
                       onPressed: ()=>Get.to(()=>EditReminderPage(widget.reminder)),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.white,size: 16,),
                           w10,
                           Text('Edit',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ) ),
                 ),
               ],
             )

           ],
         ),
       ),
     );
  }
}