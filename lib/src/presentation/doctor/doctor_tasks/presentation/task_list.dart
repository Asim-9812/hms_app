




import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medical_app/src/presentation/doctor/doctor_tasks/presentation/add_tasks.dart';
import 'package:medical_app/src/presentation/doctor/doctor_tasks/presentation/edit_task.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../notification_controller/notification_controller.dart';
import '../domain/model/task_model.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {


  late Box<TaskModel> taskBox;
  late ValueListenable<Box<TaskModel>> taskBoxListenable;
  
  int sort = 0;


  @override
  void initState() {



    super.initState();
    // notificationServices.initializeNotifications();

    // Open the Hive box
    taskBox = Hive.box<TaskModel>('doc_tasks');

    // Create a ValueListenable for the box
    taskBoxListenable = taskBox.listenable();

    // Add a listener to update the UI when the box changes
    taskBoxListenable.addListener(_onHiveBoxChanged);
  }


  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }


  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    taskBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }


  int _comparePriority(String priorityA, String priorityB) {
    if (priorityA == 'High' && priorityB == 'Low') {
      return -1; // High comes before Low
    } else if (priorityA == 'Low' && priorityB == 'High') {
      return 1; // Low comes after High
    } else {
      return 0; // Priority is the same
    }
  }



  @override
  Widget build(BuildContext context) {
    final sortList = ['by Date','by Priority'];
    final taskList = Hive.box<TaskModel>('doc_tasks').values.toList();
    final taskList2 = Hive.box<TaskModel>('doc_tasks').values.toList();

    taskList.sort((a, b) {
      // First, compare based on priorityLevel
      final priorityComparison = _comparePriority(a.priorityLevel, b.priorityLevel);

      if (priorityComparison != 0) {
        // If priority is different, return the comparison result
        return priorityComparison;
      } else {
        // If priority is the same, compare based on createdDate
        return a.createdDate.compareTo(b.createdDate);
      }
    });

    // The taskList is now sorted by priority and then by createdDate
    for (final task in taskList) {
      print(task);
    }

    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 0,
        title: Text('All tasks',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
        leading: IconButton(
          onPressed: ()=>Get.back(),
          icon: Icon(Icons.chevron_left,color: ColorManager.white,),
        ),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>AddTasks());
          } , icon: Icon(Icons.add_box_outlined,size: 20,)),
          IconButton(onPressed: (){

          } , icon: Icon(FontAwesomeIcons.filter,size: 18.sp,))
        ],

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
            children:[
              ...taskList.map((e) => Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                decoration: BoxDecoration(
                  color: ColorManager.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(vertical: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 1.2/2,
                                child: Text('${e.taskName}',style: getMediumStyle(color: ColorManager.black,fontSize: 24.sp),)),
                            w10,
                            Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: e.priorityLevel == 'High'?ColorManager.red.withOpacity(0.4):ColorManager.primary.withOpacity(0.4),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                child: Text(e.priorityLevel,style: getRegularStyle(color: ColorManager.black,fontSize:  16.sp))),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: ()=>Get.to(()=>EditTask(e)),
                                child: FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.primary,size: 20.sp,)),
                            w10,
                            InkWell(
                                onTap: () async {
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
                                              if(e.remindMe){
                                                await NotificationController.cancelNotifications(id: e.taskId);
                                              }

                                              taskBox.deleteAt(taskList2.indexOf(e));

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
                                },
                                child: FaIcon(Icons.delete_forever,color: ColorManager.red.withOpacity(0.7),size: 24.sp,)),
                          ],
                        )


                      ],
                    ),
                    if(e.taskDesc != null)
                      h10,
                    // Divider(
                    //   color: ColorManager.black,
                    // ),
                    if(e.taskDesc != null)
                    Text(e.taskDesc!,style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),),
                    Divider(
                      color: ColorManager.black,
                    ),
                    Text(e.createdDate,style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),),


                  ],
                ),
              )).toList()
            ]
          ),
        ),
      ),
    );
  }
}
