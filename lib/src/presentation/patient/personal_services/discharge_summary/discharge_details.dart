

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';

class DischargeDetails extends StatefulWidget {
  const DischargeDetails({super.key});

  @override
  State<DischargeDetails> createState() => _DischargeDetailsState();
}

class _DischargeDetailsState extends State<DischargeDetails> {
  @override
  Widget build(BuildContext context) {
    String details = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vehicula, turpis nec fringilla volutpat, tellus tortor eleifend justo, a convallis orci nisl et tellus. Nullam suscipit justo vel urna feugiat convallis. Curabitur eget sollicitudin quam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam ac turpis sed arcu feugiat imperdiet. Nunc ac turpis quis odio vestibulum gravida. Praesent feugiat facilisis dolor, quis congue mi vestibulum sit amet. Integer et est sit amet arcu sodales congue. Vivamus eget elementum odio. Aenean consequat ipsum sed libero luctus, vel sollicitudin ligula tristique. Cras quis lectus non libero feugiat luctus. Sed ac risus id arcu eleifend gravida. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Donec semper quam nec purus bibendum, a auctor elit congue. Sed bibendum lorem dui, eu facil';
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        title: Text('Discharge Summary',style: getMediumStyle(color: ColorManager.black),),
        elevation: 1,
        backgroundColor: ColorManager.white,
       leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
centerTitle:true,
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('1. Patient\'s details',)),
                      DataColumn(label: SizedBox(width: 275,)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Patient Name:')),
                            DataCell(Text('John Doe')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Patient Id:')),
                            DataCell(Text('MRM006')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Gender:')),
                            DataCell(Text('Male')),
                          ]
                      ),
                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('2. Assigned Consultant',)),
                      DataColumn(label: SizedBox(width: 238,)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Doctor Name:')),
                            DataCell(Text('John Doe')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Doctor Id:')),
                            DataCell(Text('MRM006')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Department:')),
                            DataCell(Text('Ortho')),
                          ]
                      ),

                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('3. Visit',)),
                      DataColumn(label: SizedBox(width: 275)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Admit Date:')),
                            DataCell(Text('2023-08-09')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Discharge Date:')),
                            DataCell(Text('2023-09-10')),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Discharge Diagnosis:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Discharge Diagnosis',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Discharge Disposition:')),
                            DataCell(Text('Location')),
                          ]
                      ),
                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('4. Diagnosis',)),
                      DataColumn(label: SizedBox(width: 275)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Existing Conditions Impacting Stay:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Existing Conditions Impacting Stay',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Conditions not impacting LOS:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Conditions not impacting LOS',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),

                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('5. Course while in hospital',)),
                      DataColumn(label: SizedBox(width: 212)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Presenting Complaints:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Presenting Complaints',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Summary Course in Hospital:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Summary Course in Hospital',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Investigations:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Investigations',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Interventions:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Interventions',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),

                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('6. Alerts',)),
                      DataColumn(label: SizedBox(width: 335)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Allergies:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Allergies',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),


                    ]
                ),
                DataTable(
                  headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
                  headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primaryDark),
                    dataTextStyle: getRegularStyle(color: ColorManager.black,fontSize: 18),
                    border: TableBorder.all(
                      color: ColorManager.primaryDark
                    ),
                    columns: [
                      DataColumn(label: Text('7. Discharge Plan',)),
                      DataColumn(label: SizedBox(width: 277)),

                    ],
                    rows: [
                      DataRow(
                          cells: [
                            DataCell(Text('Medications at discharge:')),
                            DataCell(InkWell(
                                onTap: ()=>_showDialog(title: 'Medications at discharge',details:details),
                                child:FaIcon(CupertinoIcons.eye_solid))),
                          ]
                      ),
                      DataRow(
                          cells: [
                            DataCell(Text('Follow ups:')),
                            DataCell(Text('In 10 - 15 days or if or when patient is in pain')),
                          ]
                      ),


                    ]
                ),
                h100
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog({
    required String title,
    required String details
}){
    showDialog(
        context: context, 
        builder: (context){
          return AlertDialog(
            title: Text('$title',style: getMediumStyle(color: ColorManager.black),),
            content: Text('$details',style: getRegularStyle(color: ColorManager.black,fontSize: 16),textAlign: TextAlign.justify,),
            actions: [
              TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: ColorManager.primary
                  ),
                  onPressed: ()=>Navigator.pop(context), child: Text('OK',style: getRegularStyle(color: ColorManager.white),))
            ],
            actionsAlignment: MainAxisAlignment.center,
          );
        }
    );
  }
}
