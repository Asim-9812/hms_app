


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';

import '../../../../core/resources/value_manager.dart';

class SugarTestDetails extends StatefulWidget {
  const SugarTestDetails({super.key});

  @override
  State<SugarTestDetails> createState() => _SugarTestDetailsState();
}

class _SugarTestDetailsState extends State<SugarTestDetails> {

  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: 1,
        title: Text('FILE-NAME',style: getMediumStyle(color: ColorManager.black,fontSize: 20),),
       leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
centerTitle:true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            h20,
            Center(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: ColorManager.black.withOpacity(0.5)
                    )
                ),
                child: DataTable(
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                    headingTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                    columns: [
                      DataColumn(label: Text('Name:')),
                      DataColumn(label: Text('John Does')),
                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Patient ID:')),
                            DataCell(Text('2055')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Date:')),
                            DataCell(Text('2023-08-09')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Age:')),
                            DataCell(Text('55')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Sex:')),
                            DataCell(Text('Male')),
                          ]
                      ),
                    ]
                ),
              ),
            ),
            h20,
            h20,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  h20,
                  Text('History :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                  h10,
                  Text('1. Cough and Fever',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                  h10,
                  Text('2. Cough and Fever',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                  h10,
                  Text('3. Cough and Fever',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                  h20,
                  h20,
                  Text('Techniques used :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                  h10,
                  Text('1. This technique was used to ct scan for this purpose',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                  h20,
                  h20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('REPORT :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                      w10,
                      Text('Report - name',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                    ],
                  ),
                  h20,
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                    width: double.infinity,
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text('Findings :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                        h20,
                        Text('1. The lungs are clear',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                        h10,
                        Text('2. Sign of hyperinflation',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                      ],
                    ),
                  ),
                  h20,
                  Container(
                    width: double.infinity,
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Impressions :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                        h20,
                        Text('COPD. No acute pulminary disease.',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                      ],
                    ),
                  ),
                  h20,
                  Container(
                    width: double.infinity,
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Recommendations :',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                        h20,
                        Text('1. COPD. No acute pulminary disease.',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                      ],
                    ),
                  ),

                  h20,
                  Container(
                    color: ColorManager.dotGrey.withOpacity(0.2),
                    padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 18.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Doctor name:',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                            w10,
                            Text('John Doe',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                          ],
                        ),
                        h10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Doctor Id:',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                            w10,
                            Text('65165',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                          ],
                        ),
                        h10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Contact no:',style: getMediumStyle(color: ColorManager.black,fontSize: 24),),
                            w10,
                            Text('9855565165',style: getRegularStyle(color: ColorManager.black,fontSize: 20),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  h100,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
