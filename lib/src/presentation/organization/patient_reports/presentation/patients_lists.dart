

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/data/model/registered_patient_model.dart';
import 'package:medical_app/src/data/services/registered_patient_services.dart';
import 'package:medical_app/src/dummy_datas/dummy_datas.dart';
import 'package:medical_app/src/presentation/organization/patient_reports/presentation/patient_profile_org.dart';
import 'package:medical_app/src/presentation/organization/patient_reports/presentation/patient_report.dart';
import '../../../../core/resources/value_manager.dart';
import '../../charts_graphs/patient_groups.dart';
import '../../charts_graphs/total_patients.dart';

class OrgPatientReports extends ConsumerStatefulWidget {
  const OrgPatientReports({super.key});

  @override
  ConsumerState<OrgPatientReports> createState() => _OrgPatientReportsState();
}

class _OrgPatientReportsState extends ConsumerState<OrgPatientReports> {


  bool _isExpanded = false;
  bool _isExpanded2 = false;
  int currentPage = 0;
  int itemsPerPage = 5;


  List<RegisteredPatientModel> getDisplayedPatients({
    required List<RegisteredPatientModel> patientList
}) {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return patientList.sublist(startIndex, endIndex);
  }

  void nextPage() {
    setState(() {
      if (currentPage < (patientData.length - 1) ~/ itemsPerPage) {
        currentPage++;
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 0) {
        currentPage--;
      }
    });
  }


  @override
  Widget build(BuildContext context) {

    final patientList = ref.watch(getPatientList);


    // Get the screen size
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primaryDark,
        centerTitle: true,
        title: Text('Patient Reports',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h20,

            Container(
              height:isWideScreen? 360:320,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children: [
                  isNarrowScreen?w10:w18,

                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorManager.primaryDark.withOpacity(0.9),
                            ColorManager.primaryDark.withOpacity(0.9),
                            ColorManager.primaryDark.withOpacity(0.75),
                            ColorManager.primaryDark.withOpacity(0.75),
                            ColorManager.primaryDark.withOpacity(0.6)
                          ],
                          stops: [0.0,0.65,0.65, 0.85,0.85],
                          transform: GradientRotation(0),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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

                                padding: EdgeInsets.symmetric(vertical: 5.w,horizontal: 10.w),
                                child: FaIcon(CupertinoIcons.person_2_fill,color: ColorManager.white,)),
                            w10,
                            Text('Total Patients',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :24.sp),)
                          ],
                        ),
                        h20,
                        Text('150 patients',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?44:44.sp),),
                        h10,
                        Text('Registered Today :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),
                        h10,
                        Text('Last 7 days :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('30',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),
                        h10,
                        Text('Last month :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('120',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),

                      ],
                    ),

                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorManager.blue,
                            ColorManager.blue,
                            ColorManager.blue.withOpacity(0.9),
                            ColorManager.blue.withOpacity(0.9),
                            ColorManager.blue.withOpacity(0.8),
                            ColorManager.blue.withOpacity(0.8),
                            ColorManager.blue.withOpacity(0.7)
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
                                child: FaIcon(CupertinoIcons.graph_square_fill,color: ColorManager.white,)),
                            w10,
                            Text('General',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :24.sp),)
                          ],
                        ),
                        h20,
                        Text('General Ward :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),
                        h10,
                        Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),

                      ],
                    ),

                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorManager.red.withOpacity(0.8),
                            ColorManager.red.withOpacity(0.8),
                            ColorManager.red.withOpacity(0.7),
                            ColorManager.red.withOpacity(0.7),
                            ColorManager.red.withOpacity(0.6),
                            ColorManager.red.withOpacity(0.6),
                            ColorManager.red.withOpacity(0.5)
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
                                child: FaIcon(Icons.emergency,color: ColorManager.white,)),
                            w10,
                            Text('Emergency',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :24.sp),)
                          ],
                        ),
                        h20,
                        Text('Emergency cases :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),
                        h10,
                        Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),

                      ],
                    ),

                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            ColorManager.orange,
                            ColorManager.orange,
                            ColorManager.orange.withOpacity(0.8),
                            ColorManager.orange.withOpacity(0.8),
                            ColorManager.orange.withOpacity(0.7),
                            ColorManager.orange.withOpacity(0.7),
                            ColorManager.orange.withOpacity(0.6)
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
                                child: FaIcon(FontAwesomeIcons.bedPulse,color: ColorManager.white,size: 20,)),
                            w10,
                            Text('Surgical Stats',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?24 :24.sp),)
                          ],
                        ),
                        h20,
                        Text('Total Operations :',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),
                        h10,
                        Text('10',style: getMediumStyle(color: ColorManager.white,fontSize: isWideScreen?40:40.sp),),
                        h10,
                        Text('Last 7 days',style: getRegularStyle(color: ColorManager.white,fontSize: isWideScreen?18:18.sp),),

                      ],
                    ),

                  ),


                ],
              ),
            ),
            h20,
            Container(

              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
              child: Column(
                children: [
                  Text('Patient Statistics',style: getMediumStyle(color: Colors.black,fontSize: 20),),
                  h10,
                  Container(
                    decoration: BoxDecoration(
                        color: ColorManager.primary,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: ExpansionPanelList(
                        expandIconColor: ColorManager.primaryDark,
                        elevation: 0,
                        expandedHeaderPadding: EdgeInsets.zero,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _isExpanded = !_isExpanded; // Toggle the expansion state
                          });
                        },
                        children:[
                          ExpansionPanel(
                            isExpanded: _isExpanded,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(

                                onTap: (){
                                  setState(() {
                                    _isExpanded = !_isExpanded; // Toggle the expansion state
                                  });
                                },
                                title: Text('Total Patients', style: getMediumStyle(color:ColorManager.black, fontSize: 20)),
                              ); // Empty header, handled above
                            },
                            body: Container(
                              width: double.infinity,
                              height: 450,
                              child: PatientChart(),
                            ),
                          ),

                        ]



                    ),
                  ),
                  h10,
                  Container(
                    decoration: BoxDecoration(
                        color: ColorManager.blue,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: ExpansionPanelList(
                        expandIconColor: ColorManager.primaryDark,
                        elevation: 0,
                        expandedHeaderPadding: EdgeInsets.zero,
                        expansionCallback: (int index, bool isExpanded) {
                          setState(() {
                            _isExpanded2 = !_isExpanded2; // Toggle the expansion state
                          });
                        },
                        children:[
                          ExpansionPanel(
                            isExpanded: _isExpanded2,
                            headerBuilder: (BuildContext context, bool isExpanded) {
                              return ListTile(
                                onTap: (){
                                  setState(() {
                                    _isExpanded2 = !_isExpanded2; // Toggle the expansion state
                                  });
                                },
                                title: Text('Patient Groups', style: getMediumStyle(color:ColorManager.black, fontSize: 20)),
                              ); // Empty header, handled above
                            },
                            body: Container(
                                width: double.infinity,
                                height: 450,
                                child: PatientGroups()
                            ),
                          ),

                        ]



                    ),
                  ),
                  h10,
                  InkWell(
                    onTap: ()=>Get.to(()=>PatientReports()),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: ColorManager.dotGrey.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorManager.black.withOpacity(0.5)
                        )
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 24.w,vertical: 8.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Patient Reports',style: getMediumStyle(color:ColorManager.black,fontSize: 20),),
                          Icon(Icons.chevron_right,color: ColorManager.black,)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            h20,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Text('Recent Patients',style: getMediumStyle(color: ColorManager.black,fontSize: 22),),
            ),
            h20,



            patientList.when(
                data: (data){
                  if(data.isEmpty){
                    return Container(
                      width: double.infinity,
                      height: 400,
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              border: TableBorder.all(
                                color: ColorManager.black.withOpacity(0.3),
                              ),
                              headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                              headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 18),
                              columns: [
                                DataColumn(label: Text('S.N.')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Age')),
                                DataColumn(label: Text('Gender')),
                                DataColumn(label: Text('Contact')),
                                DataColumn(label: Text('Address')),
                                DataColumn(label: Text('Entry Date')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: [],
                            ),
                          ),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Center(
                              child: Text('No Records',textAlign: TextAlign.center,style: getRegularStyle(color: ColorManager.black),),
                            ),
                          ),

                        ],
                      ),
                    );
                  }
                  else{
                    final displayedPatients = getDisplayedPatients(patientList: data);
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.all(
                          color: ColorManager.black.withOpacity(0.3),
                        ),
                        headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                        headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 18),
                        columns: [
                          DataColumn(label: Text('S.N.')),
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Age')),
                          DataColumn(label: Text('Gender')),
                          DataColumn(label: Text('Contact')),
                          DataColumn(label: Text('Address')),
                          DataColumn(label: Text('Entry Date')),
                          DataColumn(label: Text('Action')),
                        ],
                        rows: displayedPatients
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key + 1 + currentPage * itemsPerPage;
                          final patient = entry.value;
                          final age = DateTime
                              .now()
                              .year - patient.dob!
                              .year;
                          final gender = patient.genderID == 1
                              ? 'M'
                              : (patient.genderID == 2 ? 'F' : 'O');

                          return DataRow(
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(
                                  Text('${patient.firstName} ${patient.lastName}')),
                              DataCell(Text(age.toString())),
                              DataCell(Text(gender)),
                              DataCell(Text(patient.contact ?? '-')),
                              DataCell(Text(patient.localAddress ?? '-')),
                              DataCell(Text(patient.entryDate.toString())),
                              DataCell(
                                  IconButton(onPressed: (){

                                    _showDetails(patient: patient);

                                  },icon: FaIcon(CupertinoIcons.eye_fill,color: ColorManager.primaryOpacity80,))
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    );
                  }

                },
                error: (error,stack)=>Container(
                  width: double.infinity,
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: ColorManager.primary,
                      ),
                      Container(
                        height: 350,
                        width: double.infinity,
                        child: Center(
                          child: Text('Something went wrong\n(${error})',textAlign: TextAlign.center,style: getRegularStyle(color: ColorManager.black),),
                        ),
                      ),

                    ],
                  ),
                ),
                loading: ()=>Container(
                  width: double.infinity,
                  height: 400,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        width: double.infinity,
                        color: ColorManager.primary,
                      ),
                      Container(
                        height: 350,
                        width: double.infinity,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    ],
                  ),
                ),),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(Icons.chevron_left),
                  onPressed: currentPage > 0 ? previousPage : null,
                ),
                Text('Page ${currentPage + 1}'),
                IconButton(
                  icon: FaIcon(Icons.chevron_right),
                  onPressed: currentPage < (patientData.length - 1) ~/ itemsPerPage
                      ? nextPage
                      : null,
                ),
              ],
            ),

            h100,
            h100,
          ],
        ),
      ),
    );
  }

  Future<void> _showDetails({
    required RegisteredPatientModel patient
  }) async {
    final screenSize = MediaQuery.of(context).size;

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 420;


    ImageProvider<Object>? profileImage;

    profileImage = AssetImage('assets/icons/user.png');

    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                    image: DecorationImage(image:AssetImage('assets/images/containers/Tip-Container-3.png'),fit: BoxFit.cover),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 30.h),
                  margin: EdgeInsets.symmetric(vertical: 1),
                  child: Center(
                    child: Card(
                      shape: CircleBorder(),
                      elevation: 5,
                      child: CircleAvatar(
                        backgroundColor: ColorManager.white,
                        radius: isNarrowScreen? 40.r:40,
                        child: CircleAvatar(
                          backgroundImage: profileImage,
                          backgroundColor: ColorManager.white,
                          radius: isNarrowScreen? 35.r:35,
                        ),
                      ),
                    ),
                  ),
                ),
                h16,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                    color: ColorManager.white,
                  ),

                  padding: EdgeInsets.symmetric(horizontal: 18.w),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Name :',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                          w10,
                          Text('${patient.firstName} ${patient.lastName}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                        ],
                      ),
                      h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Contact :',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                          w10,
                          Text('${patient.contact}',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                        ],
                      ),

                      h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Consultant :',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                          w10,
                          Text('Dr. Consultant',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                        ],
                      ),
                      h10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Consult Date:',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                          w10,
                          Text('2022-02-02',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                        ],
                      ),
                      h20,
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            Get.to(()=>PatientProfileOrg(isWideScreen,isNarrowScreen));
                          },
                          child: Text('View More',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),
                        ),
                      ),
                      h20,

                    ],
                  ),
                )
              ],


            ),
          );
        }
    ) ;
  }


}