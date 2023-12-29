


import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';
import 'package:meroupachar/src/presentation/notification_controller/notification_controller.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../../../login/domain/model/user.dart';

class EditTask extends StatefulWidget {
  final TaskModel task;
  EditTask(this.task);

  @override
  State<EditTask> createState() => _DocMyTasksState();
}

class _DocMyTasksState extends State<EditTask> {


  late TaskModel task;




  final formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _dateController = TextEditingController();


  int limiter = 0;

  late int selectPriority;

  late bool reminder;

  late int id ;


  late DateTime date;



  @override
  void initState(){
    super.initState();
    task = widget.task;
    id = task.taskId;
    date = task.remindMe ? DateFormat('hh:mm a, yyyy-MM-dd').parse(task.remindDate!) : DateTime.now();
    _dateController.text =task.remindDate?? DateFormat('hh:mm a, yyyy-MM-dd').format(DateTime.now());
    _nameController.text = task.taskName;
    reminder = task.remindMe;

    selectPriority = task.priorityLevel == 'High'? 0 : 1;

    if(task.taskDesc != null){
      _descController.text = task.taskDesc!;
    }

  }


  void _updateTask(TaskModel task) {
    final taskBox = Hive.box<TaskModel>('doc_tasks');

    final int indexToUpdate = taskBox.values.toList().indexWhere((element) => element.taskId == task.taskId);


    if (indexToUpdate != -1) {
      taskBox.putAt(indexToUpdate, task);
      Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen
    } else {
      // Handle the case where the reminder is not found
      // You might want to show an error message or take appropriate action
      // based on your app's requirements.
      print('Reminder not found for update.');
    }
  }



  @override
  Widget build(BuildContext context) {

    List<String> priority = ['High','Low'];

    return GestureDetector(
      onTap:()=> FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          centerTitle: true,
          elevation: 1,
          title: Text('Edit task',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: Icon(Icons.chevron_left,color: ColorManager.white,),
          ),

        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    maxLines: null,
                    style: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    decoration: InputDecoration(
                        labelText: 'Title',
                        counter: Text('${_nameController.text.length}/50'),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black.withOpacity(0.5)
                            )
                        )
                    ),
                    onChanged: (value){
                      setState(() {
                        limiter = value.length;
                      });
                    },
                    validator: (value){
                      if(value!.trim().isEmpty){
                        return 'Title is required';

                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(50)
                    ],
                  ),
                  h10,
                  Text(' Description (optional)',style: getMediumStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 20.sp),),
                  h10,
                  Container(
                    height: 100.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    child: TextFormField(
                      maxLines: null,
                      controller: _descController,
                      style: getRegularStyle(color: ColorManager.black,fontSize: 18),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h)

                      ),
                    ),
                  ),
                  h10,
                  Row(
                    children: [

                      Text('Set a priority level :',style: getRegularStyle(color: ColorManager.black,fontSize: 20.sp),),
                      w10,
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              selectPriority = 0;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ColorManager.black.withOpacity(0.5)
                                ),
                                color: selectPriority == 0? ColorManager.red.withOpacity(0.5):Colors.transparent
                            ),
                            child: Text('High',style: getRegularStyle(color:selectPriority == 0?ColorManager.white: ColorManager.black,fontSize: 20.sp),),
                          ),
                        ),
                      ),
                      w10,
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              selectPriority = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ColorManager.black.withOpacity(0.5)
                                ),
                                color: selectPriority == 1? ColorManager.primary.withOpacity(0.7):Colors.transparent
                            ),
                            child: Text('Low',style: getRegularStyle(color:selectPriority == 1?ColorManager.white: ColorManager.black,fontSize: 20.sp),),
                          ),
                        ),
                      ),

                    ],
                  ),
                  h20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Text('Remind me',style: getRegularStyle(color: ColorManager.black,fontSize: 20.sp),),
                      Checkbox(
                        value: reminder,
                        onChanged: (onChanged){
                          setState(() {
                            reminder = !reminder;
                          });
                        },
                        activeColor: ColorManager.primary,
                      ),
                      if(reminder)
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _selectDate(context), // Show date picker for start date when tapped
                            child: AbsorbPointer(
                              child: TextFormField(
                                controller: _dateController,
                                decoration: InputDecoration(
                                  suffixIconConstraints: BoxConstraints.tightForFinite(),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: FaIcon(Icons.calendar_month,color: ColorManager.primaryDark,),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5))),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5))),
                                  labelText: 'Date',
                                  labelStyle: getRegularStyle(color: ColorManager.black, fontSize: 16),
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please select a start date';
                                  }
                                  if(date.isBefore(DateTime.now())){
                                    return 'Invalid time';
                                  }
                                  return null;
                                },
                                autovalidateMode: AutovalidateMode.onUserInteraction,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  h20,
                  Center(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            fixedSize: Size.fromWidth(300.w)
                        ),
                        onPressed: () async {
                          if(formKey.currentState!.validate()){

                            final userBox = Hive.box<User>('session').values.toList();
                            TaskModel newTask = TaskModel(
                                taskId: id,
                                userId: userBox[0].userID!,
                                taskName: _nameController.text,
                                priorityLevel: priority[selectPriority],
                                taskDesc: _descController.text.isNotEmpty? _descController.text : null,
                                createdDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                remindMe: reminder,
                                remindDate: reminder? _dateController.text : null
                            );


                            if(reminder && _dateController.text != task.remindDate){
                              // print(newTask);
                                await NotificationController.scheduleTaskNotification(context,reminder: newTask);
                            }


                            _updateTask(newTask);

                          }

                        },
                        child: Text('Update',style: getRegularStyle(color: ColorManager.white),)
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {


    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate:DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );




    if(selectedDate!= null){

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime:TimeOfDay.now(),
      );

      if(picked != null){
        DateTime remindDate = DateTime(selectedDate.year,selectedDate.month,selectedDate.day,picked.hour,picked.minute);
        setState(() {
          date = remindDate;
        });
        _dateController.text = DateFormat('hh:mm a, yyyy-MM-dd').format(remindDate);
      }

    }

  }





}
