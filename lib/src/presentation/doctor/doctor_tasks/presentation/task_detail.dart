



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/presentation/edit_task.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../notification_controller/notification_controller.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';

class TaskDetail extends StatelessWidget {
  final TaskModel task;
  TaskDetail(this.task);

  @override
  Widget build(BuildContext context) {
    final taskList = Hive.box<TaskModel>('doc_tasks').values.toList();
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          h10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width * 1/2,
                  child: Text(task.taskName,style: getMediumStyle(color: ColorManager.black,fontSize: 24.sp),)),
              InkWell(
                  onTap: (){
                    Navigator.pop(context);
                    Get.to(()=>EditTask(task));
                  },
                  child: FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.black,size: 18.sp,))
            ],
          ),
          if(task.taskDesc != null)
          h20,
          if(task.taskDesc != null)
          Text(task.taskDesc!,style: getRegularStyle(color: ColorManager.black,fontSize: 20.sp),),

          Divider(
            color: ColorManager.black,
          ),
          Text(task.createdDate,style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),),
          h10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary
                    ),
                    onPressed: ()=>Navigator.pop(context),
                    child: Text('OK',style: getRegularStyle(color: ColorManager.white,fontSize: 16.sp),)),
              ),
              w10,
              Expanded(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorManager.red.withOpacity(0.7),
                      elevation: 0
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
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
                                      final taskBox = Hive.box<TaskModel>('doc_tasks');

                                      if(task.remindMe){
                                        await NotificationController.cancelNotifications(id: task.taskId);
                                      }

                                      taskBox.deleteAt(taskList.indexOf(task));

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
                    child: Text('Delete',style: getRegularStyle(color: ColorManager.white,fontSize: 16.sp),)),
              ),
            ],
          )


        ],
      ),
    );
  }
}
