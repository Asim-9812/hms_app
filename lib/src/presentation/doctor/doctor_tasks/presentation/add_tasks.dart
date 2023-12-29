


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

class AddTasks extends StatefulWidget {
  const AddTasks({super.key});

  @override
  State<AddTasks> createState() => _DocMyTasksState();
}

class _DocMyTasksState extends State<AddTasks> {

  // Map<String,dynamic> tasks = {
  //   'taskId' : 1,
  //   'userId' : '1001',
  //   'taskName' : 'Re-up with new patients',
  //   'taskDesc' : null,
  //   'priorityLevel' : 'High',
  //   'createdDate' : '2080-09-09'
  // };


  DateTime date = DateTime.now();


  final formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _dateController = TextEditingController();


  int limiter = 0;
  
  int selectPriority = 1;

  bool reminder = false;



  @override
  void initState(){
    super.initState();
    _dateController.text = DateFormat('hh:mm a, yyyy-MM-dd').format(DateTime.now());

  }


  void _addTask(TaskModel task) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    final taskBox = Hive.box<TaskModel>('doc_tasks');

    await taskBox.add(task);
    scaffoldMessage.showSnackBar(
      SnackbarUtil.showSuccessSnackbar(
        message: 'Reminder saved !',
        duration: const Duration(milliseconds: 1400),
      ),
    );

    Navigator.pop(context,true); // Optionally, you can navigate back to the previous screen

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
          title: Text('Add a task',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
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
                                  return 'Invalid Time';
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
                          TaskModel task = TaskModel(
                              taskId: Random().nextInt(1000),
                              userId: userBox[0].userID!,
                              taskName: _nameController.text,
                              priorityLevel: priority[selectPriority],
                              taskDesc: _descController.text.isNotEmpty? _descController.text : null,
                              createdDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                              remindMe: reminder,
                            remindDate: reminder? _dateController.text : null
                          );

                          if(reminder){
                            await NotificationController.scheduleTaskNotification(context,reminder: task);
                          }

                          _addTask(task);

                        }

                        },
                        child: Text('Add',style: getRegularStyle(color: ColorManager.white),)
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
