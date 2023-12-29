import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/presentation/add_tasks.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/presentation/edit_task.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../../notification_controller/notification_controller.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';




class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {


  late Box<TaskModel> taskBox;
  late ValueListenable<Box<TaskModel>> taskBoxListenable;


  List<TaskModel> searchResults = [];




  TextEditingController _searchController = TextEditingController();

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





  void onSearchTextChanged(String searchText, List<TaskModel> data) {
    searchResults.clear();
    if (searchText.isEmpty) {
      setState(() {});
      return;
    }

    data.forEach((item) {
      if (item.taskName.toLowerCase().contains(searchText.toLowerCase()) ||
          item.createdDate.toLowerCase().contains(searchText.toLowerCase())||
          item.priorityLevel.toLowerCase().contains(searchText.toLowerCase())) {
        searchResults.add(item);
      }
    });

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('session').values.toList().first;
    final taskList = Hive.box<TaskModel>('doc_tasks').values.where((element) => element.userId == userBox.userID).toList();
    final taskList2 = Hive.box<TaskModel>('doc_tasks').values.toList();




    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: AppBar(
        toolbarHeight: 100,
        centerTitle: true,
        backgroundColor: ColorManager.primary.withOpacity(0.8),
        elevation: 1,
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () => Get.back(),
              child: Icon(Icons.chevron_left, color: ColorManager.white),
            ),
            w20,
            Expanded(
              child: TextFormField(
                controller: _searchController,
                onChanged: (value)=>onSearchTextChanged(value , taskList),
                autofocus: true,
                style: getRegularStyle(color: ColorManager.black, fontSize: 18),
                decoration: InputDecoration(
                  fillColor: ColorManager.white,
                  filled: true,
                  hintText: 'Search...',
                  hintStyle: getRegularStyle(color: ColorManager.textGrey, fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5), width: 0.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5), width: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
        child: SingleChildScrollView(
          child: Column(
              children:[
                if (searchResults.isNotEmpty)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      String fileName = searchResults[index].taskName;
                      String date = searchResults[index].createdDate;

                      return Container(
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
                                        child: Text('$fileName',style: getMediumStyle(color: ColorManager.black,fontSize: 24.sp),)),
                                    w10,
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: searchResults[index].priorityLevel == 'High'?ColorManager.red.withOpacity(0.4):ColorManager.primary.withOpacity(0.4),
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                        child: Text(searchResults[index].priorityLevel,style: getRegularStyle(color: ColorManager.black,fontSize:  16.sp))),
                                  ],
                                ),
                                Row(
                                  children: [
                                    InkWell(
                                        onTap: ()=>Get.to(()=>EditTask(searchResults[index])),
                                        child: FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.primary,size: 20.sp,)),
                                    w10,
                                    InkWell(
                                        onTap: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context){
                                                return AlertDialog(
                                                  shape: ContinuousRectangleBorder(
                                                    borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  content: Text('Do you want to delete this reminder?',style: getRegularStyle(color: ColorManager.black),),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton.styleFrom(
                                                            backgroundColor: ColorManager.primaryDark
                                                        ),
                                                        onPressed: ()async{
                                                          if(searchResults[index].remindMe){
                                                            await NotificationController.cancelNotifications(id: searchResults[index].taskId);
                                                          }
                                                          // print(e.taskId);
                                                          // print(taskList2.firstWhere((element) => element==e).taskId);

                                                          taskBox.deleteAt(taskList2.indexOf(searchResults[index]));

                                                          Navigator.pop(context);
                                                          Get.back();
                                                        }, child: Text('Yes',style: TextStyle(color: ColorManager.white),)),
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
                            if(searchResults[index].taskDesc != null)
                              h10,
                            // Divider(
                            //   color: ColorManager.black,
                            // ),
                            if(searchResults[index].taskDesc != null)
                              Text(searchResults[index].taskDesc!,style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),),
                            Divider(
                              color: ColorManager.black,
                            ),
                            Text(searchResults[index].createdDate,style: getRegularStyle(color: ColorManager.black,fontSize: 16.sp),),


                          ],
                        ),
                      );
                    },
                  ),
                if (searchResults.isEmpty)
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                    child: Text('No matching files found...', style: getRegularStyle(color: ColorManager.white)),
                  ),
              ]
          ),
        ),
      ),
    );
  }
}
