import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/data/services/department_services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:meroupachar/src/presentation/patient_reports/presentation/patient_view_profile.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';
import '../../login/domain/model/user.dart';
import '../../patient_documents/add_documents/presentation/add_document_page.dart';
import '../domain/model/patient_report_model.dart';
import '../domain/services/patient_report_services.dart';




class PatientReports extends ConsumerStatefulWidget {
  final String userCode;
  final String userId;
  PatientReports({required this.userCode,required this.userId});

  @override
  ConsumerState<PatientReports> createState() => _PatientReportsState();
}

class _PatientReportsState extends ConsumerState<PatientReports> {
  TextEditingController dateFrom = TextEditingController();
  TextEditingController dateTo = TextEditingController();
  TextEditingController search = TextEditingController();
  TextEditingController phController = TextEditingController();
  bool _phCheck = false;
  int departmentId = 0;
  String userId = "0";
  String consultantId = '0';
  int pgId = 0;
  List<PatientReportModel> reportList = [];
  int currentPage = 0;
  int itemsPerPage = 5;
  final formKey = GlobalKey<FormState>();
  GlobalKey<DropdownSearchState<String>> dropdownSearchKey = GlobalKey();
  String resetList = '';
  String searchQuery = '';
  String selectedDepartment = 'All';
  String selectedUser = 'All';
  String selectedConsultant = 'All';
  String selectedPatientGroup = 'All';
  bool validate = false;
  bool hide = true;

  List<UserListModel> userList = [];
  List<ConsultantModel> consultantList = [];

  List<PatientReportModel> filteredReportList = [];

  late String userCode;

  @override
  void initState() {
    super.initState();
    dateFrom.text = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));
    dateTo.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    userCode = widget.userCode;
    phController.text = userCode;
    _getUsers();

  }

  bool reportAttributesContainSearchQuery(PatientReportModel report, String searchQuery) {

    return [
      report.departmentConsult ?? '',
      report.address ?? '',
      report.fullName ?? '',
      report.patientinfo ?? '',
      // Add more attributes as needed
    ].any((attribute) => attribute.toLowerCase().contains(searchQuery));
  }


  void filterReportList() {
    if(search.text.isEmpty){

      filteredReportList = reportList;
    }
    filteredReportList = reportList
        .where((report) =>
    (report.fullName ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.patientinfo ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.patientID ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.address ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.contact ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.departmentName ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        (report.typeId ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
        reportAttributesContainSearchQuery(report, searchQuery.toLowerCase())
    )
        .toList();
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

  void _getUsers() async {
    List<UserListModel> list = await PatientReportServices().getUsersList(code: userCode);
    setState(() {
      userList = list;
    });
    _getConsultant();

  }

  void _getConsultant() async {

    List<ConsultantModel> list = await PatientReportServices().getConsultantList(userId: userId == "0" ?widget.userId: userId );
    setState(() {
      consultantList = list;
    });
    // print('executed');
  }

  @override
  Widget build(BuildContext context) {
    final userBox = Hive.box<User>('session').values.toList();
    final departmentList = ref.watch(getDepartmentList);
    final doctorsList = ref.watch(getUsersDropDown(userCode));
    final patientGroupList = ref.watch(getPatientGroups);
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorManager.primaryDark,
          title: Text('PH Reports',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
          centerTitle: true,
          automaticallyImplyLeading: false,
          //leading: userBox.typeID == 3 ? null:IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.white,)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  h20,
                  Row(
                    children: [

                      Expanded(
                        child: AbsorbPointer(
                          absorbing: !_phCheck,
                          child: TextFormField(
                            controller: phController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor:_phCheck == false? ColorManager.dotGrey.withOpacity(0.3):  ColorManager.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: _phCheck == false? ColorManager.white : ColorManager.black
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:  _phCheck == false? ColorManager.white : ColorManager.black
                                  )
                              ),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:  _phCheck == false? ColorManager.white : ColorManager.black
                                  )
                              ),
                              floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                              labelText: 'PH Code',
                              labelStyle: getRegularStyle(color: ColorManager.black),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(_phCheck){
                                if (value!.isEmpty) {
                                  return 'Required code';
                                }
                                if (value.length < 2 && value.length > 6 ) {
                                  return 'Invalid code';
                                }
                                if (value.contains(' ')) {
                                  return 'Do not enter spaces';
                                }
                              }

                              return null;
                            },
                          ),
                        ),
                      ),
                      w10,
                      Checkbox(
                        activeColor: ColorManager.primary,
                          value: _phCheck,
                          onChanged: (value){
                            FocusScope.of(context).unfocus();

                            formKey.currentState!.reset();
                            reportList = [];
                            dateFrom.text = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 7)));
                            dateTo.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
                            selectedDepartment = 'All';
                            departmentId = 0 ;
                            userId = '0';
                            selectedUser = 'All';
                            consultantId = '0';
                            selectedConsultant = 'All';
                            pgId = 0;
                            selectedPatientGroup = 'All';
                            search.clear();
                            setState(() {
                              _phCheck = value!;
                              phController.clear();
                            });
                          }
                      )
                    ],
                  ),
                  if(_phCheck == false)
                    h20,
                  if(_phCheck == false)
                  Column(
                    children: [
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
                                        return 'Invalid Date';
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
                                    labelStyle: getRegularStyle(color: ColorManager.primary),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today,color: ColorManager.primary,),
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
                                    labelStyle: getRegularStyle(color: ColorManager.primary),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today,color: ColorManager.primary,),
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
                                resetList = 'All';
                              });
                              return DropdownSearch<String>(

                                items: ['All',...data.map((e) => e.departmentName).toList()],
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:  ColorManager.accentGreen.withOpacity(0.5)
                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:  ColorManager.accentGreen.withOpacity(0.5)
                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      labelText: "Department",
                                      labelStyle: getRegularStyle(color: ColorManager.primary)
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedDepartment = value!;
                                  });
                                  final selected = data.firstWhereOrNull((element) => element.departmentName.contains(value!));
                                  if(selected != null){
                                    setState(() {
                                      departmentId = selected.departmentId;

                                    });
                                  }
                                  else if(selected == null && value == 'All'){
                                    setState(() {
                                      departmentId = 0;

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


                                selectedItem: selectedDepartment,
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
                          error: (error,stack)=>DropdownSearch(
                            selectedItem: '$error',
                            items: [],
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  ColorManager.accentGreen.withOpacity(0.5)
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  ColorManager.accentGreen.withOpacity(0.5)
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  labelText: "Departments",
                                  labelStyle: getRegularStyle(color: ColorManager.primary)
                              ),
                            ),
                          ),
                          loading: ()=>DropdownSearch(
                            selectedItem: 'Loading...',
                            items: [],
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  ColorManager.accentGreen.withOpacity(0.5)
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:  ColorManager.accentGreen.withOpacity(0.5)
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  labelText: "Departments",
                                  labelStyle: getRegularStyle(color: ColorManager.primary)
                              ),
                            ),
                          )
                      ),
                      h20,
                      if(userList.isNotEmpty)
                        DropdownSearch<String>(

                          items: ['All',...userList.map((e) => '${e.firstName} ${e.lastName}').toList()],
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Users",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedUser = value!;
                            });
                            // print(selectedDoctor.split(' ')[0]);
                            final selected = userList.firstWhereOrNull((element) => '${element.firstName} ${element.lastName}' == selectedUser);
                            if(selected != null){
                              setState(() {
                                userId = selected.userID!;

                              });
                              _getConsultant();
                            }
                            else if(selected == null && value == 'All'){
                              setState(() {
                                userId = widget.userId;

                              });
                              _getConsultant();
                            }
                            else{
                              setState(() {
                                userId = '-1';
                              });
                            }



                          },


                          selectedItem: selectedUser,
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
                        ),

                      if(userList.isEmpty)
                        DropdownSearch<String>(

                          items: ['No Users'],
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Users",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),


                          selectedItem: 'No Users',
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
                        ),

                      h20,

                      if(consultantList.isNotEmpty)
                        DropdownSearch<String>(

                          items: ['All',...consultantList.map((e) => '${e.firstName} ${e.lastName}').toList()],
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Consultants",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              selectedConsultant = value!;
                            });
                            // print(selectedDoctor.split(' ')[0]);
                            final selected = consultantList.firstWhereOrNull((element) => '${element.firstName} ${element.lastName}' == selectedConsultant);
                            if(selected != null){
                              setState(() {
                                consultantId = selected.userID;

                              });
                            }
                            else if(selected == null && value == 'All'){
                              setState(() {
                                consultantId = '0';

                              });
                            }
                            else{
                              setState(() {
                                consultantId = '-1';
                              });
                            }


                          },


                          selectedItem: selectedConsultant,
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
                        ),

                      if(consultantList.isEmpty && userList.isNotEmpty)
                        DropdownSearch<String>(
                          items: ['All'],
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Consultants",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),


                          selectedItem: selectedConsultant,
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
                        ),

                      if(consultantList.isEmpty && userList.isEmpty)
                        DropdownSearch<String>(


                          items: ['No Consultants'],
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:  ColorManager.accentGreen.withOpacity(0.5)
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                labelText: "Consultants",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),


                          selectedItem: 'No Consultants',
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
                        ),


                      h20,
                      patientGroupList.when(
                          data: (data){
                            if(data.isEmpty){
                              return SizedBox();
                            }
                            else{
                              setState(() {
                                resetList = 'All';
                              });
                              return DropdownSearch<String>(

                                items: ['All',...data.map((e) => e.groupName!).toList()],
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:  ColorManager.accentGreen.withOpacity(0.5)
                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:  ColorManager.accentGreen.withOpacity(0.5)
                                          ),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      labelText: "PH Group",
                                      labelStyle: getRegularStyle(color: ColorManager.primary)
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    selectedPatientGroup = value!;
                                  });
                                  // print(selectedDoctor.split(' ')[0]);
                                  final selected = data.firstWhereOrNull((element) => element.groupName == selectedPatientGroup);
                                  if(selected != null){
                                    setState(() {
                                      pgId = selected.patientGroupId!;

                                    });
                                  }
                                  else if(selected == null && value == 'All'){
                                    setState(() {
                                      pgId = 0;

                                    });
                                  }
                                  else{
                                    setState(() {
                                      pgId = -1;
                                    });
                                  }

                                },


                                selectedItem: selectedPatientGroup,
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
                            child: Text('PH Group'),
                          )
                      ),
                      h20,
                    ],
                  ),

                  if(_phCheck == true)
                  h20,

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary

                          ),
                          onPressed: ()async{
                            final userBox = Hive.box<User>('session').values.toList();
                            // String firstName = userBox[0].firstName!;



                            final scaffoldMessage = ScaffoldMessenger.of(context);
                            if(userList.isEmpty && consultantList.isEmpty){
                              scaffoldMessage.showSnackBar(
                                SnackbarUtil.showFailureSnackbar(
                                  message: 'No Data Available',
                                  duration: const Duration(milliseconds: 1200),
                                ),
                              );
                            }

                            else{
                              if(formKey.currentState!.validate()){
                                if(_phCheck){
                                  final response = await PatientReportServices().getReportList(
                                      fromDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                      toDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                      departmentId: "0",
                                      userId: "0",
                                      patientGroupId: 0,
                                      code: userBox[0].code!,
                                      patientId: phController.text.trim(),
                                      consultantId: consultantId
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
                                    filteredReportList = response;
                                  });
                                }
                                else{
                                  final response = await PatientReportServices().getReportList(
                                      fromDate: dateFrom.text,
                                      toDate: dateTo.text,
                                      departmentId: departmentId.toString(),
                                      userId: userId,
                                      patientGroupId: pgId,
                                      code: userBox[0].code!,
                                      patientId: "0",
                                      consultantId: consultantId
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
                                    filteredReportList = response;
                                  });
                                }
                              }
                            }




                          },
                          child: Text('Search',style: getRegularStyle(color: ColorManager.white,fontSize: 18),)
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
                              selectedDepartment = 'All';
                              departmentId = 0 ;
                              userId = '0';
                              selectedUser = 'All';
                              consultantId = '0';
                              selectedConsultant = 'All';
                              pgId = 0;
                              selectedPatientGroup = 'All';
                              search.clear();
                              phController.clear();
                              formKey.currentState!.reset();

                            });

                          },
                          child: Text('Reset',style: getRegularStyle(color: ColorManager.black,fontSize: 18),)
                      ),
                    ],
                  ),
                  h20,


                  if(reportList.isNotEmpty)
                  TextFormField(
                    controller: search,
                    decoration: InputDecoration(
                      fillColor: ColorManager.primary.withOpacity(0.2),
                      filled: true,
                      hintText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: ColorManager.primary
                        )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.primary
                      ),

                  ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                    ),
                  ),
                    onChanged: (value){
                      setState(() {
                        searchQuery = value;
                        filterReportList();
                      });
                    },

                  ),
                  h10,

                  if(reportList.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        border: TableBorder.symmetric(
                          outside: BorderSide(
                            color: ColorManager.black.withOpacity(0.5)
                          )
                        ),
                        headingRowColor: MaterialStateColor.resolveWith((states) => ColorManager.primary),
                        headingTextStyle: getMediumStyle(color: ColorManager.white,fontSize: 18),
                        columns: [
                          DataColumn(label: Text('S.N.')),
                          DataColumn(label: Text('PH Code')),
                          DataColumn(label: Text('Full Name')),
                          DataColumn(label: Text('Age/Sex')),
                          DataColumn(label: Text('Address')),
                          DataColumn(label: Text('Contact')),
                          DataColumn(label: Text('Department')),
                          DataColumn(label: Text('Type')),
                          DataColumn(label: Text('Action/View')),
                        ],
                        rows: filteredReportList
                            .asMap()
                            .entries
                            .map((entry) {
                          final index = entry.key + 1 + currentPage * itemsPerPage;
                          final patient = entry.value;
                          bool patientColorIsLight() {
                            Color patientColor = patient.colorCode == null ? Colors.white : Color(int.parse(patient.colorCode!.replaceAll('#', '0xFF')));
                            double luminance = patientColor.computeLuminance();

                            // You can adjust this threshold based on your preference
                            return luminance > 0.5;
                          }

                          return DataRow(
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 8.h),
                                decoration: BoxDecoration(
                                  color: HexColor.fromHex(patient.colorCode == null ? '#ffffff' :"${patient.colorCode}" ),
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: ColorManager.black.withOpacity(0.5)
                                  )
                                ),
                                child: Text('${patient.patientID}',style: TextStyle(color:patientColorIsLight() ? ColorManager.black:ColorManager.white),),
                              )),
                              DataCell(Text('${patient.fullName}')),
                              DataCell(Text('${patient.patientinfo}')),
                              DataCell(Text(patient.address == null ? '-':'${patient.address}')),
                              DataCell(Text('${patient.contact}')),
                              DataCell(Text('${patient.departmentConsult}')),
                              DataCell(Text('${patient.typeId}')),
                              DataCell(
                                  Row(
                                    children: [
                                      IconButton(onPressed: ()=>Get.to(()=>AddDocuPatients(userId:patient.patientID!)),
                                          icon: FaIcon(CupertinoIcons.add_circled,color: ColorManager.orange.withOpacity(0.7),)),
                                      // IconButton(onPressed: ()=>Get.to(()=>ViewProfile(patientCode: patient.patientID!,colorCode: patient.colorCode == null? '#ffffff' : patient.colorCode!,patientAddress: patient.address!,)),
                                      //     icon: FaIcon(CupertinoIcons.eye_fill,color: ColorManager.primary,)),
                                    ],
                                  )
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  h100,
                  h100,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
