import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/data/services/department_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:medical_app/src/presentation/organization/patient_reports/domain/services/patient_report_services.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../common/snackbar.dart';
import '../domain/model/patient_report_model.dart';

class PatientReports extends ConsumerStatefulWidget {
  const PatientReports({Key? key}) : super(key: key);

  @override
  ConsumerState<PatientReports> createState() => _PatientReportsState();
}

class _PatientReportsState extends ConsumerState<PatientReports> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  int departmentId = -1;
  List<PatientReportModel> reportList = [];
  int currentPage = 0;
  int itemsPerPage = 5;
  final formKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState<String>> dropdownSearchKey = GlobalKey();
  String resetList = '';
  String selectedItem = 'Select a department';
  bool validate = false;



  @override
  void initState() {
    super.initState();
    dateFrom.text = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));
    dateTo.text = DateFormat('yyyy-MM-dd').format(DateTime.now());

  }


  List<PatientReportModel> getDisplayedPatients({
    required List<PatientReportModel> patientList
  }) {
    final startIndex = currentPage * itemsPerPage;
    final endIndex = startIndex + itemsPerPage;
    return patientList.sublist(startIndex, endIndex);
  }

  void nextPage() {
    setState(() {
      if (currentPage < (reportList.length - 1) ~/ itemsPerPage) {
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


  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller == dateFrom? DateTime.parse(dateFrom.text): DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
  }

  @override
  Widget build(BuildContext context) {
    final departmentList = ref.watch(getDepartmentList);
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Reports'),
        centerTitle: true,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.white,)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              h20,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, dateFrom),
                      child: AbsorbPointer(
                        absorbing: true, // Disable input
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value!.isEmpty){
                              return '';
                            }
                            else if(dateTo.text.isNotEmpty){
                              if(DateTime.parse(value).isAfter(DateTime.parse(dateTo.text))){
                                return 'Greater than To Date';
                              }
                            }
                            return null;
                          },
                          controller: dateFrom,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black.withOpacity(0.4)
                                )
                            ),
                            labelText: 'From',
                            labelStyle: getRegularStyle(color: ColorManager.blue),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today,color: ColorManager.blue,),
                              onPressed: () => _selectDate(context, dateFrom),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  w10,
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, dateTo),
                      child: AbsorbPointer(
                        absorbing: true, // Disable input
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(value!.isEmpty){
                              return '';
                            }
                            return null;
                          },
                          controller: dateTo,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black.withOpacity(0.4)
                                )
                            ),
                            labelText: 'To',
                            labelStyle: getRegularStyle(color: ColorManager.blue),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.calendar_today,color: ColorManager.blue,),
                              onPressed: () => _selectDate(context, dateTo),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              h20,
              departmentList.when(
                  data: (data){
                    if(data.isEmpty){
                      return SizedBox();
                    }
                    else{
                      setState(() {
                        resetList = 'Select a department';
                      });
                      return DropdownSearch<String>(

                        items: ['Select a department',...data.map((e) => e.departmentName).toList()],
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:  ColorManager.accentGreen.withOpacity(0.5)
                                  ),
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              labelText: "Department",
                              labelStyle: getRegularStyle(color: ColorManager.blue)
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value!;
                          });
                          final selected = data.firstWhereOrNull((element) => element.departmentName.contains(value!));
                          if(selected != null){
                            setState(() {
                              departmentId = selected.departmentId;

                            });
                          }
                          else{
                            setState(() {
                              departmentId = -1;
                            });
                          }

                        },
                        validator: (value){
                          if(departmentId == -1){
                            return 'Select a department';
                          }
                          return null;
                        },
                        autoValidateMode: AutovalidateMode.onUserInteraction,


                        selectedItem: selectedItem,
                        popupProps: const PopupProps<String>.menu(

                          showSearchBox: true,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(maxHeight: 350),
                          showSelectedItems: true,
                          searchFieldProps: TextFieldProps(
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                      ;

                    }
                  },
                  error: (error,stack)=>Center(child: Text('$error'),),
                  loading: ()=>Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Text('Departments'),
                  )
              ),
              h20,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.blue

                      ),
                      onPressed: ()async{

                        final scaffoldMessage = ScaffoldMessenger.of(context);

                        if(formKey.currentState!.validate()){
                            final response = await PatientReportServices().getReportList(
                                fromDate: dateFrom.text,
                                toDate: dateTo.text,
                                departmentId: departmentId.toString()
                            );
                            if(response.isEmpty){


                              scaffoldMessage.showSnackBar(
                                SnackbarUtil.showFailureSnackbar(
                                  message: 'No Data Available',
                                  duration: const Duration(milliseconds: 1200),
                                ),
                              );
                            }
                            setState(() {
                              reportList = response;
                            });


                        }


                      },
                      child: Text('Search')
                  ),
                  w20,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: ColorManager.dotGrey.withOpacity(0.7)

                      ),
                      onPressed: ()async{
                        setState(() {
                          reportList = [];
                          dateFrom.text = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));
                          dateTo.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          selectedItem = 'Select a department';
                          departmentId = -1 ;

                        });

                      },
                      child: Text('Clear',style: TextStyle(color: ColorManager.black),)
                  ),
                ],
              ),
              h20,
              if(reportList.isNotEmpty)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(
                      color: ColorManager.black.withOpacity(0.3),
                    ),
                    headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.blue),
                    headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 18),
                    columns: [
                      DataColumn(label: Text('S.N.')),
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Information')),
                      DataColumn(label: Text('Department')),
                      DataColumn(label: Text('Entry Date')),
                      DataColumn(label: Text('Action')),
                    ],
                    rows: reportList
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key + 1 + currentPage * itemsPerPage;
                      final patient = entry.value;

                      return DataRow(
                        cells: [
                          DataCell(Text(index.toString())),
                          DataCell(
                              Text('${patient.fullName}')),
                          DataCell(Text('${patient.patientinfo}')),
                          DataCell(Text('${patient.departmentName}')),
                          DataCell(Text(patient.entrydate.toString())),
                          DataCell(
                              IconButton(onPressed: (){ },
                                  icon: FaIcon(CupertinoIcons.eye_fill,color: ColorManager.blue,))
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )

            ],
          ),
        ),
      ),
    );
  }
}
