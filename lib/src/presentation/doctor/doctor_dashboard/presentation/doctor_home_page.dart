import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/dummy_datas/dummy_datas.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/domain/model/task_model.dart';
import 'package:meroupachar/src/presentation/doctor/doctor_tasks/presentation/task_detail.dart';
import 'package:meroupachar/src/presentation/patient_reports/domain/services/patient_report_services.dart';
import 'package:meroupachar/src/presentation/patient_reports/domain/model/patient_report_model.dart';
import '../../../../core/api.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../doctor_tasks/presentation/add_tasks.dart';
import '../../doctor_tasks/presentation/task_list.dart';


class DoctorHomePage extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final bool noticeBool;
  final User user;
  DoctorHomePage(this.isWideScreen,this.isNarrowScreen,this.noticeBool,this.user);

  @override
  ConsumerState<DoctorHomePage> createState() => _DoctorHomePageState();
}

class _DoctorHomePageState extends ConsumerState<DoctorHomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();


  late Box<TaskModel> taskBox;
  late ValueListenable<Box<TaskModel>> taskBoxListenable;

  List<Map<String, dynamic>> myCircle = [{
    "name": "Add a member",
    "specializeIn": "",
  },...closeCircle];

  List<Map<String, dynamic>> myPatients = patientList;

  int currentPage = 0;
  final int rowsPerPage = 5;


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

    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   showAlertDialog2(context,widget.code,ref);
    // });

  }


  void _onHiveBoxChanged() {
    // This function will be called whenever the Hive box changes.
    // You can update your UI or refresh the data here.
    setState(() {
      // Update your data or UI as needed
    });
  }



  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //
  //   if(widget.noticeBool){
  //     // Schedule the _showAlertDialog method to be called after the build is complete.
  //     Future.delayed(Duration.zero, () {
  //       showAlertDialog(context,widget.code);
  //     });
  //   }
  //
  // }


  @override
  void dispose() {
    // Be sure to remove the listener when the widget is disposed.
    taskBoxListenable.removeListener(_onHiveBoxChanged);
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = widget.user.firstName!;
    String lastName = widget.user.lastName!;
    // final profileImg = ref.watch(imageProvider);
    // ImageProvider<Object>? profileImage;
    //
    // if (profileImg != null) {
    //   profileImage = Image.file(File(profileImg.path)).image;
    // } else if (userBox[0].profileImage == null) {
    //   profileImage = AssetImage('assets/icons/user.png');
    // } else {
    //   profileImage = NetworkImage('${Api.baseUrl}/${userBox[0].profileImage}');
    // }

    final params = Tuple2(widget.user.code!, widget.user.token!);

    final docCircle = ref.watch(getUsersDropDown(params));


    return FadeIn(
      delay: Duration(milliseconds: 200),
      duration: Duration(milliseconds: 500),
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: ColorManager.white,
          endDrawerEnableOpenDragGesture: false,

          appBar: AppBar(
              backgroundColor: ColorManager.primaryDark,
              elevation: 0,
              toolbarHeight: 120,
              centerTitle: true,
              titleSpacing: 0,
              title: Container(
                width: double.infinity,
                height: 120,
                // padding: EdgeInsets.symmetric(horizontal: 18.w),
                decoration: BoxDecoration(
                  //color: ColorManager.primary         //for dynamic logo....
                    image: DecorationImage(image: AssetImage('assets/images/banner1111.png'),fit: BoxFit.fitWidth)
                ),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: CircleAvatar(
                        backgroundColor: ColorManager.white,
                        backgroundImage: userBox[0].profileImage == null ? null : NetworkImage('${Api.baseUrl}/${widget.user.profileImage}'),
                        radius: 30,
                        child:userBox[0].profileImage != null ? null :FaIcon(FontAwesomeIcons.user,color: ColorManager.black,),
                      ),
                    ),
                    w10,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Welcome,',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),

                        Text('$firstName $lastName',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
                      ],
                    ),
                  ],
                ),



                ///for dynamic logo....
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.only(left: 18.w),
                //           child: Card(
                //             shape: CircleBorder(
                //                 side: BorderSide(
                //                     color: ColorManager.primary,
                //                     width: 1
                //                 )
                //             ),
                //             child: CircleAvatar(
                //               backgroundColor: ColorManager.white,
                //               backgroundImage: profileImage,
                //               radius: 30,
                //             ),
                //           ),
                //         ),
                //         w10,
                //         Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //
                //             Text('Welcome,',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),
                //
                //             Text('$firstName $lastName',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
                //           ],
                //         ),
                //       ],
                //     ),
                //     Container(
                //       decoration: BoxDecoration(
                //         color: ColorManager.white,
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(30),
                //           bottomLeft: Radius.circular(30)
                //         ),
                //         image: DecorationImage(image: AssetImage('assets/images/logo001.png'),fit:BoxFit.fitHeight)
                //       ),
                //       width: 130,
                //       height: 70,
                //     ),
                //   ],
                // ),
              )
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // InkWell(
                //   // onTap: ()=>Get.to(()=>SearchNearByPage(),transition: Transition.fadeIn),
                //   splashColor: ColorManager.primary.withOpacity(0.4),
                //   child: Center(
                //     child: Container(
                //         height: 50.h,
                //         width: 390.w,
                //         padding: EdgeInsets.symmetric(horizontal: 18.w),
                //         decoration: BoxDecoration(
                //             color: ColorManager.searchColor.withOpacity(0.15),
                //             borderRadius: BorderRadius.circular(20),
                //             border: Border.all(
                //                 color:ColorManager.searchColor,
                //                 width: 1
                //             )
                //         ),
                //         child: Row(
                //           mainAxisSize: MainAxisSize.max,
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                //             Row(
                //               children: [
                //                 Icon(Icons.search,color: ColorManager.iconGrey,),
                //                 w10,
                //                 Text('Search medical...',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?15.sp:15),),
                //               ],
                //             ),
                //             SizedBox()
                //           ],
                //         )
                //     ),
                //   ),
                // ),
                h20,
                _overallStat(),
                // h20,
                // _patientGraph(),

                h20,
                _myTasks(),

                h20,
                _myAppointments(),

                h20,
                h20,
                _myCircle(docCircle,userBox[0].userID!),
                h20,
                h20,

                h100,
              ],

            ),
          )
      ),
    );
  }


  Widget _overallStat() {



    return Container(
      height: widget.isWideScreen? 200:150,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          widget.isNarrowScreen?w10:w18,
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.primary,
                    ColorManager.primary,
                    ColorManager.primary.withOpacity(0.9),
                    ColorManager.primary.withOpacity(0.9),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.7)
                  ],
                  stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
                  transform: GradientRotation(5),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
            height:widget.isWideScreen?200:160.h,
            width: 280.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:ColorManager.white.withOpacity(0.3),
                        ),

                        padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
                        child: FaIcon(CupertinoIcons.graph_square_fill,color: ColorManager.white,)),
                    w10,
                    Text('Patients',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Patients :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.6),
                    ColorManager.primary.withOpacity(0.6),
                    ColorManager.primary.withOpacity(0.5)
                  ],
                  stops: [0.0,0.6,0.6, 0.7,0.7,0.8,0.8],
                  transform: GradientRotation(6),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.mirror
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
            height:160.h,
            width: 280.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:ColorManager.white.withOpacity(0.3),
                        ),

                        padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
                        child: FaIcon(Icons.task_rounded,color: ColorManager.white,)),
                    w10,
                    Text('Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Appointments :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    ColorManager.primary,
                    ColorManager.primary,
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.8),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.7),
                    ColorManager.primary.withOpacity(0.6)
                  ],
                  stops: [0.0,0.65,0.65,0.75,0.75, 0.85,0.85],
                  transform: GradientRotation(1),
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.repeated
              ),
              borderRadius: BorderRadius.circular(20),

            ),
            margin: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
            height:160.h,
            width: 280.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:ColorManager.white.withOpacity(0.3),
                        ),

                        padding: EdgeInsets.symmetric(vertical: 8.w,horizontal: 10.w),
                        child: FaIcon(Icons.currency_exchange,color: ColorManager.white,size: 20,)),
                    w10,
                    Text('Revenue',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?24 :widget.isNarrowScreen?18.sp:24.sp),)
                  ],
                ),
                h20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Revenue :',style: getRegularStyle(color: ColorManager.white,fontSize: widget.isWideScreen?18:widget.isNarrowScreen?16.sp:18.sp),),

                    Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: widget.isWideScreen?40:widget.isNarrowScreen?30.sp:40.sp),),
                  ],
                ),

              ],
            ),

          ),


        ],
      ),
    );
  }


  Widget _myCircle(AsyncValue<List<UserListModel>> docCircle , String userId){
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                // color: ColorManager.orange.withOpacity(0.2),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                // border:Border.all(
                //     color: ColorManager.black.withOpacity(0.4)
                // )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Circle',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                InkWell(
                  onTap: (){},
                  child: Text('See more',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                ),
              ],
            ),

          ),


          docCircle.when(
              data: (data){
                data.removeWhere((element) => element.userID == userId);
                return  Container(
                    height: 180,
                    width: double.infinity,
                    child: ListView.builder(
                      itemCount:data.length ,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      itemBuilder: (context , i){
                        return InkWell(
                          onTap: (){},
                          //()=>Get.to(()=>DocProfilePage()),
                          child: Container(
                            decoration: BoxDecoration(
                                color: ColorManager.dotGrey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: ColorManager.black.withOpacity(0.5)
                                )
                            ),
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: ColorManager.white,
                                  radius: 30.r,
                                  child: Image.asset('assets/icons/doctor.png',filterQuality: FilterQuality.high,fit: BoxFit.contain),
                                ),
                                h20,
                                Text('${data[i].firstName} ${data[i].lastName}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                                
                              ],
                            ),
                          ),
                        );
                      },
                    )

                );
              },

              error: (error,stack)=>Text('$error'),

              loading: ()=>SpinKitDualRing(color: ColorManager.primary)),



        ],
      ),
    );
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



  Widget _myTasks(){
    final userBox = Hive.box<User>('session').values.toList();
    final taskList = Hive.box<TaskModel>('doc_tasks').values.where((element) => element.userId == userBox[0].userID).toList();

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


    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 8),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('My Tasks',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
                InkWell(
                    onTap: ()=>Get.to(()=>AddTasks()),
                    child: FaIcon(Icons.add,color: ColorManager.white,)),
              ],
            ),

          ),
          if(taskList.isNotEmpty)
          Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...taskList.take(6).map((e) =>  InkWell(
                    onTap: ()async{
                      await showDialog(
                          context: context,
                          builder: (context){
                            return TaskDetail(e);
                          }
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                      decoration:BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                            right: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                            left: BorderSide(
                                color: ColorManager.black.withOpacity(0.5),
                                width: 0.5
                            ),
                          )
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('${taskList.indexOf(e) + 1}.',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?16.sp:16),),
                              w10,
                              Container(
                                  width: widget.isNarrowScreen?150: widget.isWideScreen? 275:200,
                                  child: Text('${e.taskName}',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),)),


                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: e.priorityLevel == 'High'?ColorManager.red.withOpacity(0.4):ColorManager.primary.withOpacity(0.4),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                  child: Text(e.priorityLevel,style: getRegularStyle(color: ColorManager.black,fontSize:  widget.isNarrowScreen?16.sp:16))),
                              w10,
                              Text('${e.createdDate}',style: getRegularStyle(color: ColorManager.black,fontSize: 12),),
                            ],
                          ),


                        ],
                      ),
                    ),
                  )).toList(),
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                    //   decoration:BoxDecoration(
                    //       border: Border(
                    //         bottom: BorderSide(
                    //             color: ColorManager.black.withOpacity(0.5),
                    //             width: 0.5
                    //         ),
                    //         right: BorderSide(
                    //             color: ColorManager.black.withOpacity(0.5),
                    //             width: 0.5
                    //         ),
                    //         left: BorderSide(
                    //             color: ColorManager.black.withOpacity(0.5),
                    //             width: 0.5
                    //         ),
                    //       )
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Text('${i+1}.',style: getRegularStyle(color: ColorManager.black),),
                    //           w10,
                    //           Container(
                    //               width: widget.isNarrowScreen?150: widget.isWideScreen? 275:200,
                    //               child: Text('${dummyTasks[i]}',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?16.sp:16),)),
                    //           w10,
                    //           Container(
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(50),
                    //                 color: i%2==0?ColorManager.red.withOpacity(0.4):ColorManager.primary.withOpacity(0.4),
                    //               ),
                    //               padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                    //               child: Text(i%2==0?'High':'Low',style: getRegularStyle(color: ColorManager.black,fontSize:  widget.isNarrowScreen?16.sp:16))),
                    //         ],
                    //       ),
                    //       Text('2080-08-09',style: getRegularStyle(color: ColorManager.black,fontSize: 12),),
                    //
                    //
                    //     ],
                    //   ),
                    // )
                ],
              )

          ),
          if(taskList.isEmpty)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
              decoration:BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                        color: ColorManager.black.withOpacity(0.5),
                        width: 0.5
                    ),
                    right: BorderSide(
                        color: ColorManager.black.withOpacity(0.5),
                        width: 0.5
                    ),
                    left: BorderSide(
                        color: ColorManager.black.withOpacity(0.5),
                        width: 0.5
                    ),
                  )
              ),
              child: Center(child: Text('Add a task \'+\'',style: getMediumStyle(color: ColorManager.black,fontSize: 20.sp),),),
            ),
          if(taskList.isNotEmpty)
          InkWell(
            onTap: ()=>Get.to(()=>TaskList()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.5),

                ),
              ),
              child: Center(
                child: Text('See more', style: getMediumStyle(color: ColorManager.black, fontSize: 16)),
              ),
            )

          ),
        ],
      ),
    );
  }


  Widget _myAppointments(){
    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isExtraWide = screenSize.width > 1000;
    return Container(

      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorManager.primary.withOpacity(0.8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                )
            ),
            child: Text('My Appointments',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),

          ),
          Container(
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      vertical: BorderSide(
                          color: ColorManager.black.withOpacity(0.4)
                      )
                  )
              ),
              width: double.infinity,
              child: Column(
                children: [
                  for(int i = 0; i< 5;i++)
                    Column(
                      children: [
                        Container(
                          color: ColorManager.dotGrey.withOpacity(0.1),
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          // height: 120.h,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration:BoxDecoration(
                                    color: ColorManager.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: ColorManager.black.withOpacity(0.5),
                                        width: 0.5
                                    )
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 18.h),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('25',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?18:widget.isNarrowScreen?18.sp:24),),
                                    h10,
                                    Text('wed',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?14:widget.isNarrowScreen?14.sp:18),)
                                  ],
                                ),
                              ),
                              w10,
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: ColorManager.primary.withOpacity(0.4),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 5.h),
                                            child: Text('10:${40+(i*2)} am',style: getRegularStyle(color: ColorManager.primary,fontSize: isExtraWide?12:widget.isNarrowScreen?14.sp:16),)),
                                        h16,
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('${appointments[i]['appointmentTitle']}',style: getMediumStyle(color: ColorManager.black,fontSize: isExtraWide?16:widget.isNarrowScreen?18.sp:20),),
                                            h10,
                                            Text('${appointments[i]['patientName']}',style: getRegularStyle(color: ColorManager.black,fontSize: isExtraWide?12:widget.isNarrowScreen?16.sp:18),),
                                          ],
                                        ),

                                      ],
                                    ),
                                    FaIcon(Icons.more_vert,color: ColorManager.black,size: isExtraWide?20:widget.isNarrowScreen?20.sp:24,)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: ColorManager.black.withOpacity(0.4),
                        ),
                      ],
                    ),

                ],
              )

          ),
          InkWell(
            onTap: (){},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                border: Border.all(
                  color: ColorManager.black.withOpacity(0.5)
                )
              ),
              child: Center(
                  child: Text('See more',style: getMediumStyle(color: ColorManager.black,fontSize: 16),)),

            ),
          ),
        ],
      ),
    );
  }

}

