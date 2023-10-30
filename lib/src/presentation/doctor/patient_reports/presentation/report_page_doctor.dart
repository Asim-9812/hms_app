



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../dummy_datas/dummy_datas.dart';
import '../../patient_profile/presentation/doctor_patient_profile_page.dart';

class PatientReportPageDoctor extends StatefulWidget {
  const PatientReportPageDoctor({super.key});

  @override
  State<PatientReportPageDoctor> createState() => _PatientReportPageDoctorState();
}

class _PatientReportPageDoctorState extends State<PatientReportPageDoctor> {

  int currentPage = 0;
  final int rowsPerPage = 5;

  Widget _patientTable(){

    int startIndex = currentPage * rowsPerPage;
    int endIndex = (currentPage + 1) * rowsPerPage;

    List<DataRow> rows = patientList.sublist(startIndex, endIndex).map((patient) {
      return DataRow(cells: [
        DataCell(Text((startIndex + patientList.indexOf(patient) + 1).toString())), // Serial Number (S.N.)
        DataCell(Text(patient['name'])),
        DataCell(Text(patient['address'])),
        DataCell(Text(patient['contact'])),
        DataCell(Text(patient['department'])),
        DataCell(Text(patient['gender'])),
        DataCell(IconButton(
          icon: Icon(Icons.remove_red_eye),
          onPressed: ()=>Get.to(()=>DocPatientProfile()),
        )),
      ]);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 20),
            headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
            columns: [
              DataColumn(label: Text('S.N.')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Contact')),
              DataColumn(label: Text('Department')),
              DataColumn(label: Text('Gender')),
              DataColumn(label: Text('Action')),
            ],
            rows: rows,
          ),
        ),
        h10,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.navigate_before),
              onPressed: () {
                if (currentPage > 0) {
                  setState(() {
                    currentPage--;
                  });
                }
              },
            ),
            Text('Page ${currentPage + 1}'),
            IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: () {
                if (endIndex < patientList.length) {
                  setState(() {
                    currentPage++;
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        centerTitle: true,
        elevation: 1,
        title: Text('Reports',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),

      ),
      body: Column(
        children: [
          _patientTable()
        ],
      ),
    );
  }


}
