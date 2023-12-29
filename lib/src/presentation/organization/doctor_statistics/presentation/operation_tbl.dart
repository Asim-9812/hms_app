


import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/style_manager.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../dummy_datas/dummy_datas.dart';

class OperationTable extends StatefulWidget {
  const OperationTable({super.key});

  @override
  State<OperationTable> createState() => _OperationTableState();
}

class _OperationTableState extends State<OperationTable> {
  bool _isExpanded = true;

  int currentPage = 0;

  int itemsPerPage = 5;

  List<Map<String, dynamic>> getDisplayedPatients() {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return patientData.sublist(startIndex, endIndex);
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
    return _operationTable();
  }

  Widget _operationTable(){
    final displayedPatients = getDisplayedPatients();
    return Column(
      children: [

        // SingleChildScrollView(
        //   scrollDirection: Axis.horizontal,
        //   child: DataTable(
        //     dataRowColor: MaterialStateColor.resolveWith((states) => ColorManager.dotGrey.withOpacity(0.2)),
        //     headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary.withOpacity(0.7)),
        //     headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 18),
        //     columns: [
        //       DataColumn(label: Text('S.N.')),
        //       DataColumn(label: Text('Name')),
        //       DataColumn(label: Text('Age')),
        //       DataColumn(label: Text('Gender')),
        //       DataColumn(label: Text('Contact')),
        //       DataColumn(label: Text('Address')),
        //       DataColumn(label: Text('Action')),
        //     ],
        //     rows:[]
        //     //
        //     // displayedPatients
        //     //     .asMap()
        //     //     .entries
        //     //     .map((entry) {
        //     //   final index = entry.key + 1 + currentPage * itemsPerPage;
        //     //   final patient = entry.value;
        //     //   final age = DateTime
        //     //       .now()
        //     //       .year - DateTime
        //     //       .parse(patient['dob'])
        //     //       .year;
        //     //   final gender = patient['genderID'] == 1
        //     //       ? 'M'
        //     //       : (patient['genderID'] == 2 ? 'F' : 'O');
        //     //
        //     //   return DataRow(
        //     //     cells: [
        //     //       DataCell(Text(index.toString())),
        //     //       DataCell(
        //     //           Text('${patient['firstName']} ${patient['lastName']}')),
        //     //       DataCell(Text(age.toString())),
        //     //       DataCell(Text(gender)),
        //     //       DataCell(Text(patient['contact'])),
        //     //       DataCell(Text(patient['localAddress'])),
        //     //       DataCell(Text(patient['entryDate'].toString())),
        //     //       DataCell(Text('View/Edit')),
        //     //     ],
        //     //   );
        //     // }).toList(),
        //   ),
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     IconButton(
        //       icon: FaIcon(Icons.chevron_left),
        //       onPressed: currentPage > 0 ? previousPage : null,
        //     ),
        //     Text('Page ${currentPage + 1}'),
        //     IconButton(
        //       icon: FaIcon(Icons.chevron_right),
        //       onPressed: currentPage < (patientData.length - 1) ~/ itemsPerPage
        //           ? nextPage
        //           : null,
        //     ),
        //   ],
        // ),
        h20,
        Center(
          child: Text('No data',style: getMediumStyle(color: ColorManager.black),),
        )
      ],
    );
  }
}
