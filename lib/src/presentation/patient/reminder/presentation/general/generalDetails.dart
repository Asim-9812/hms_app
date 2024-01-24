
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/patient/reminder/domain/model/general_reminder_model.dart';
import 'package:meroupachar/src/presentation/patient/reminder/presentation/general/widget/edit_general_page.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';
import '../../../../notification_controller/notification_controller.dart';

class GeneralDetails extends StatefulWidget {
  final GeneralReminderModel reminder;

  GeneralDetails(this.reminder);

  @override
  State<GeneralDetails> createState() => _GeneralDetailsState();
}

class _GeneralDetailsState extends State<GeneralDetails> {

  GlobalKey<_GeneralDetailsState> refreshKey = GlobalKey();



  late Box<GeneralReminderModel> reminderBox;
  late ValueListenable<Box<GeneralReminderModel>> reminderBoxListenable;





  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    reminderBox = Hive.box<GeneralReminderModel>('general_reminder_box');

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


    final reminder = Hive.box<GeneralReminderModel>('general_reminder_box');

    final int index = reminder.values.toList().indexWhere((element) => element.reminderId == widget.reminder.reminderId);

    final reminderBox = reminder.getAt(index)!;



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
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                     Text('${reminderBox.title}',style: getSemiBoldStyle(color: ColorManager.black,fontSize: 32),),
                     h10,
                     Text('${reminderBox.reminderPattern.patternName}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                   ],
                 ),
                 Text('${reminderBox.time}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
               ],
             ),
             h20,
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 color: ColorManager.primaryDark,
                 borderRadius: BorderRadius.circular(10),
               ),
               padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Description',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                   h10,
                   Text('${reminderBox.description}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)



                 ],
               ),
             ),

             h20,
             Container(
               width: double.infinity,
               decoration: BoxDecoration(
                 color: ColorManager.primaryDark,
                 borderRadius: BorderRadius.circular(10),
               ),
               padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text('Start Date',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                   h10,
                   Text('${DateFormat('yyyy-MM-dd').format(reminderBox.startDate)}',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),

                 ],
               ),
             ),
             h20,
             Row(
               children: [

                 Expanded(
                   child: ElevatedButton(
                     style: ElevatedButton.styleFrom(
                       backgroundColor: ColorManager.primary,
                       elevation: 0
                     ),
                       onPressed: ()=>Get.to(()=>EditGeneralReminder(reminderBox)),
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.white,size: 16,),
                           w10,
                           Text('Edit',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
                         ],
                       ) ),
                 ),
                 w10,
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
                                       onPressed: ()async{

                                         for(int i = 0 ; i < reminderBox.contentIdList!.length ; i++){
                                           await NotificationController.cancelNotifications(id: reminderBox.contentIdList![i]);
                                         }

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
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: [
                           FaIcon(Icons.delete,color: ColorManager.white,size: 16,),
                           w10,
                           Text('Delete',style: getRegularStyle(color: ColorManager.white,fontSize: 18),),
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