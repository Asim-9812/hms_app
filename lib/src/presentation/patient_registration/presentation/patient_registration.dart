





import 'dart:io';
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/value_manager.dart';
import 'package:medical_app/src/data/model/country_model.dart';
import 'package:medical_app/src/data/model/department_model.dart';
import 'package:medical_app/src/data/provider/common_provider.dart';
import 'package:medical_app/src/data/services/country_services.dart';
import 'package:medical_app/src/data/services/department_services.dart';
import 'package:medical_app/src/presentation/common/date_input_formatter.dart';
import 'package:medical_app/src/presentation/login/domain/model/user.dart';
import 'package:medical_app/src/presentation/patient/quick_services/domain/services/cost_category_services.dart';
import 'package:medical_app/src/presentation/patient/quick_services/domain/services/patient_registration_service.dart';
import '../../../core/resources/style_manager.dart';
import '../../../data/services/user_services.dart';
import '../../common/snackbar.dart';
import '../../patient/quick_services/domain/model/cost_category_model.dart';

class PatientRegistrationForm extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  PatientRegistrationForm(this.isWideScreen,this.isNarrowScreen);

  @override
  ConsumerState<PatientRegistrationForm> createState() => _ETicketState();
}

class _ETicketState extends ConsumerState<PatientRegistrationForm> {
  List<String> genderType = ['Select Gender','Male', 'Female', 'Other'];
  String selectedGender = 'Select Gender';
  int genderId = 0;
  final formKey = GlobalKey<FormState>();
  bool isPostingData = false;

  DateTime? selectedDOB;
  DateTime? selectedDate;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _consultController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _uhidController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _policyController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  int imageSet = 1;

  List<Country> countries = [];
  int? countryId;
  String? selectedCountry;

  List<ProvinceModel> provinces = [];
  int? provinceId;
  String selectedProvince ='Select a Province';

  List<DistrictModel> districts = [];
  int? districtId;
  String selectedDistrict = 'Select a District';


  List<MunicipalityModel> municipalities = [];
  int? municipalityId;
  String selectedMunicipality = 'Select a Municipality';



  List<CostCategoryModel> costCategory = [];
  int? costId ;
  String selectedCategory = 'Select a Category';


  List<Department> departments = [];
  int? departmentId ;
  String selectedDepartment ='Select a Department';

  List<User> doctors = [];
  int? doctorId ;
  String selectedDoctor = 'Select a Doctor';



  @override
  void initState() {
    super.initState();

    _getCountry();
    _getCostCategory();
    _getDepartment();
    _getDoctors();

  }



  /// fetch country list...
  void _getCountry() async {
    List<Country> countryList = await CountryService().getCountry();
    setState(() {
      countries = countryList;
      selectedCountry = countries.isNotEmpty ? countries[0].countryName : 'Select a country';
      countryId = countries.isNotEmpty ? countries[0].countryId : 0;
    });
    _getProvince();
  }

  /// fetch province list...
  void _getProvince() async {
    List<ProvinceModel> provinceList = await CountryService().getProvince(countryId: countryId!);
    setState(() {
      provinces = provinceList;
      provinceId = provinces.isNotEmpty ? provinces[0].provinceId : 0;

    });
    _getDistrict();
  }


  /// fetch district list...

  void _getDistrict() async {

    List<DistrictModel> districtList = await CountryService().getDistrict(provinceId: provinceId!);
    setState(() {
      districts = districtList;
      districtId = districts.isNotEmpty ? districts[0].districtId : 0;
    });
    _getMunicipality();
  }


  /// fetch municipality list...

  void _getMunicipality() async {

    List<MunicipalityModel> municipalityList = await CountryService().getMunicipality(districtId: districtId!);
    setState(() {
      municipalities = municipalityList;
      municipalityId = municipalities.isNotEmpty ? municipalities[0].municipalityId : 0;
    });
  }

  ///fetch cost category list...
  void _getCostCategory() async {
    List<CostCategoryModel> costCategoryList = await CostCategoryServices().getCostCategoryList();
    setState(() {
      costCategory = costCategoryList;
      costId =costCategory.isNotEmpty ? costCategory[0].costCategoryID  : 0;

    });
  }


  ///fetch department list...
  void _getDepartment() async {
    List<Department> departmentList = await DepartmentServices().getDoctorDepartments();
    setState(() {
      departments = departmentList;
      departmentId =departments.isNotEmpty ? departments[0].departmentId  : 0;
    });
  }


  ///fetch all doctor list...
  void _getDoctors() async {
    List<User> doctorList = await UserService().getDoctors();
    setState(() {
      doctors = doctorList;
      doctorId =doctors.isNotEmpty ? doctors[0].id  : 0;
    });
  }




  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    if(controller == _dobController){
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _dobController.text.isNotEmpty? DateTime.parse(_dobController.text):DateTime.now(),
        firstDate:DateTime(1900),
        lastDate:DateTime.now(),
      );
      if (picked != null && picked != DateTime.now())
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
    else{
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _consultController.text.isNotEmpty? DateTime.parse(_consultController.text):DateTime.now(),
        firstDate:DateTime.now(),
        lastDate:DateTime.now().add(Duration(days: 30)),
      );
      if (picked != null && picked != DateTime.now())
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }

  }



  @override
  Widget build(BuildContext context) {
    final image = ref.watch(imageProvider);
    if(image != null){
      setState(() {
        imageSet =1 ;
      });
    }
    if (costCategory.isEmpty) {
      // If costCategory is empty, show the loading spinner
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitDualRing(
            size: 50.sp,
            color: ColorManager.primary,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          backgroundColor: ColorManager.primaryOpacity80,
          elevation: 1,
          leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(Icons.chevron_left,color: ColorManager.white,),
          ),
          title: Text('Register',style: getMediumStyle(color: ColorManager.white,fontSize: 24),),
          centerTitle: true,
        ),
        body: _buildRegistration(),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 20.h),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                backgroundColor: ColorManager.primaryDark,
                fixedSize: Size.fromHeight(widget.isNarrowScreen?40.h:40)
            ),
            onPressed: isPostingData ? null :() async {
              final now = DateTime.now();
              final scaffoldMessage = ScaffoldMessenger.of(context);
              if (formKey.currentState!.validate()){

                if(image == null){
                  setState(() {
                    imageSet = 2;
                  });
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showFailureSnackbar(
                      message: 'Please provide a image',
                      duration: const Duration(milliseconds: 1400),
                    ),
                  );
                }
                else{
                  setState(() {
                    isPostingData = true;
                  });

                  final response = await ref.read(patientRegistrationProvider).addRegistration(
                      id: 1,
                      patientID: 1,
                      firstName: _firstNameController.text.trim(),
                      lastName: _lastNameController.text.trim(),
                      DOB: selectedDOB.toString(),
                      imagePhoto: 1,
                      countryID: countryId!,
                      provinceID: provinceId!,
                      districtID: districtId!,
                      municipalityID: municipalityId!,
                      ward: int.parse(_wardController.text),
                      localAddress: _addressController.text.trim(),
                      genderID: genderId == 0?3 :genderId,
                      NID: int.parse(_nidController.text),
                      UHID: int.parse(_uhidController.text),
                      entryDate: DateTime.now().toString(),
                      flag: '',
                      consultDate: selectedDate.toString(),
                      patientVisitID: 1,
                      costCategoryID: costId!,
                      departmentID: departmentId!,
                      referedByID: 0,
                      TPID: 1,
                      policyNo:_policyController.text.isEmpty?0:int.parse(_policyController.text),
                      claimCode: 1,
                      serviceCategoryID: 1,
                      ledgerID: 1,
                      imagePhotoUrl: image,
                      email: _emailController.text.trim(),
                      contact: int.parse(_mobileController.text),
                      entrydate1: DateTime.now().toString(),
                      doctorID: doctorId!,
                      code : _codeController.text.trim()

                  );


                  if (response.isLeft()) {
                    final leftValue = response.fold(
                          (left) => left,
                          (right) => '', // Empty string here as we are only interested in the left value
                    );

                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showFailureSnackbar(
                        message: leftValue,
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                    setState(() {
                      isPostingData = false;
                    });
                  }
                  else {
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showSuccessSnackbar(
                        message: 'Successfully Registered',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                    setState(() {
                      isPostingData = false;
                    });
                    Get.back();
                  }

                }

              }
              else{
                scaffoldMessage.showSnackBar(
                  SnackbarUtil.showFailureSnackbar(
                    message: 'Please fill a valid form',
                    duration: const Duration(milliseconds: 1400),
                  ),
                );
                setState(() {
                  isPostingData = false;
                });
              }

            },
            child: isPostingData? SpinKitDualRing(color: ColorManager.white,size: widget.isNarrowScreen?12.sp: 12,):Text('Register'),
          ),
        ),
      ),
    );
  }

  Widget _buildRegistration(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _nameDetails(),
              h20,
              _patientDetails(),
              h20,
              _register(),
              h100,



            ],
          ),
        ),
      ),
    );
  }

  Column _nameDetails(){

    (costId);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name',style: getMediumStyle(color: ColorManager.black,fontSize:widget.isNarrowScreen?16.sp: 18),),
        h10,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: widget.isNarrowScreen?60.h:60,
              width: 180.w,
              child: TextFormField(
                controller: _firstNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if (value!.isEmpty) {
                    return 'First Name is required';
                  }
                  if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                    return 'Invalid Name. Only use letters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                    hintText: 'First Name',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black
                        )
                    )
                ),
              ),
            ),
            Container(
              height: 60,
              width: 180.w,
              child: TextFormField(
                controller: _lastNameController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if (value!.isEmpty) {
                    return 'Last Name is required';
                  }
                  if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                    return 'Invalid Name. Only use letters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                    hintText: 'Last Name',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black
                        )
                    )
                ),
              ),
            ),
          ],
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('National ID',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
                  width: 180.w,
                  child: TextFormField(
                    controller: _nidController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'National ID is required';
                      }
                      if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                        return 'Invalid ID. Only use numbers';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                        hintText: 'National ID',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Unviersal Health ID',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
                  width: 180.w,
                  child: TextFormField(
                    controller: _uhidController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'ID is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                        hintText: 'Universal Health Id',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Registration Details',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?20.sp:20),),
            Container(
              width:widget.isNarrowScreen?160.sp:210,
              child: Divider(
                thickness: 0.5,
                color: ColorManager.black.withOpacity(0.5),
              ),
            )
          ],
        ),
        h20,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cost Category',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 80,
                  width: 180.w,
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: widget.isWideScreen?200:400.h,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    padding: EdgeInsets.zero,
                    value: selectedCategory,
                    validator: (value){
                      if(selectedCategory == 'Select a Category'){
                        return 'Please select a Category';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                    ),
                    items: [DropdownMenuItem(
                        value: 'Select a Category',
                        child: Text('Select a Category',style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?18.sp:18),
                          overflow: TextOverflow.ellipsis,)),...costCategory
                        .map(
                          (CostCategoryModel item) => DropdownMenuItem<String>(
                        value: item.costCategoryType,
                        child: Text(
                          item.costCategoryType,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?18.sp:18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList()],
                    onChanged: (String? value) {
                      setState(() {
                        selectedCategory = value!;
                        costId = costCategory.firstWhere(
                              (costCategory) => costCategory.costCategoryType == value,
                          orElse: () => CostCategoryModel(costCategoryID: 0, costCategoryType: '', isActive: false),
                        ).costCategoryID;
                      });
                      ('$costId');
                    },
                  ),
                ),
              ],
            ),

            if(selectedCategory != 'General'&&selectedCategory != 'Select a Category')
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Policy No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                  h10,
                  Container(
                    height: 80,
                    width: 180.w,
                    child: TextFormField(
                      controller: _policyController,
                      keyboardType: TextInputType.phone,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if(value !=null){
                          if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                            return 'Please enter a valid Policy no.';
                          }
                          else{
                            return null;
                          }
                        }


                        return null;
                      },
                      decoration: InputDecoration(
                          floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                          hintText: 'Policy No.',
                          hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: ColorManager.black
                              )
                          )
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        h20,
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
            h10,
            Container(
              height: 60,
              width: 180.w,
              child: TextFormField(
                controller: _codeController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value){
                  if (value!.isEmpty) {
                    return 'Required';
                  }
                  if (value.length !=3) {
                    return 'Invalid Code';
                  }
                  if (value.contains(' ')) {
                    return 'Do not enter spaces';
                  }
                  if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                    return 'Invalid';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                    hintText: 'Code',
                    hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black
                        )
                    )
                ),
              ),
            ),
          ],
        ),
        h10,


      ],
    );
  }

  Column _patientDetails(){

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Patient Details',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?20.sp:20),),
            Container(
              width: widget.isNarrowScreen?180.w: 250,
              child: Divider(
                thickness: 0.5,
                color: ColorManager.black.withOpacity(0.5),
              ),
            )
          ],
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DOB',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18 ),),
                h10,
                Container(
                  width: 180.w,
                  height: 80,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Dob is required';
                      }

                      // Create a regular expression pattern to match 'yyyy-MM-dd' format
                      final pattern = r'^\d{4}-\d{2}-\d{2}$';
                      final regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Invalid Date';
                      }

                      // Split the date string into parts
                      final dateParts = value.split('-');

                      // Ensure there are three parts (year, month, day)
                      if (dateParts.length != 3) {
                        return 'Invalid Date';
                      }

                      final year = int.tryParse(dateParts[0]);
                      final month = int.tryParse(dateParts[1]);
                      final day = int.tryParse(dateParts[2]);

                      if (year == null || month == null || day == null) {
                        return 'Invalid Date';
                      }

                      // Check if the month is invalid
                      if (month < 1 || month > 12) {
                        return 'Invalid Month';
                      }

                      // Check if the day is invalid for the selected month
                      if (day < 1 || day > DateTime(year, month + 1, 0).day) {
                        return 'Day must be between 1 and ${DateTime(year, month, 0).day}';
                      }

                      // Get the current date
                      final currentDate = DateTime.now();

                      // Check if the selected date is in the future
                      if (DateTime(year, month, day).isAfter(currentDate)) {
                        return 'Date cannot be in the future';
                      }

                      print(value);

                      return null;
                    },

                    inputFormatters: [
                      DateInputFormatter()
                    ],
                    controller: _dobController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.4)
                          )
                      ),
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,color: ColorManager.blue,),
                        onPressed: () => _selectDate(context, _dobController),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gender',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 80,
                  width: 180.w,
                  child: DropdownButtonFormField<String>(

                    padding: EdgeInsets.zero,
                    value: selectedGender,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if(selectedGender == genderType[0]){
                        return 'Please select a Gender';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                    ),
                    items: genderType
                        .map(
                          (String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedGender = value!;
                        genderId = genderType.indexOf(value);
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        h20,
        Text('Moblie No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 60,
          child: TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if (value!.isEmpty) {
                return 'Mobile number is required';
              }
              if (value.length!=10) {
                return 'Enter a valid number';
              }

              if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                return 'Please enter a valid Mobile Number';
              }
              return null;
            },
            decoration: InputDecoration(
              floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
              hintText: 'Mobile Number',
              hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: ColorManager.black
                  )
              ),
            ),
          ),
        ),
        h20,
        Text('Email',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 60,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autovalidateMode:
            AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
            decoration: InputDecoration(
                floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                hintText: 'E-mail',
                hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.black
                    )
                )
            ),
          ),
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Country',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 80,
                  width: 180.w,
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: widget.isWideScreen?200:400.h,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    padding: EdgeInsets.zero,
                    value: selectedCountry,
                    validator: (value){
                      if(selectedCountry == 'Select a Country'){
                        return 'Please select a Country';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                    ),
                    items: countries
                        .map(
                          (Country item) => DropdownMenuItem<String>(
                        value: item.countryName,
                        child: Text(
                          item.countryName,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedCountry = value!;
                        countryId = countries.firstWhere(
                              (country) => country.countryName == value,
                          orElse: () => Country(countryId: 0, countryName: '', isActive: false),
                        ).countryId;
                      });
                      _getProvince();
                      _getDistrict();
                      _getMunicipality();

                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Province',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 80,
                  width: 180.w,
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: widget.isWideScreen?200:400.h,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    padding: EdgeInsets.zero,
                    value: selectedProvince,
                    validator: (value){
                      if(selectedProvince == 'Select a Province'){
                        return 'Please select a Province';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                    ),
                    items: [DropdownMenuItem<String>(
                      value: 'Select a Province',
                      child: Text(
                        'Select a Province',
                        style: getRegularStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),...provinces.where((element) => element.countryId == countryId)
                        .map(
                          (ProvinceModel item) => DropdownMenuItem<String>(
                        value: item.provinceName,
                        child: Text(
                          item.provinceName,
                          style: getRegularStyle(color: Colors.black),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList()],
                    onChanged: (String? value) {
                      setState(() {
                        selectedProvince = value!;
                        provinceId = provinces.firstWhere(
                              (province) => province.provinceName == value,
                          orElse: () => ProvinceModel(provinceId: 0, provinceName: '', isActive: false, countryId: 0),
                        ).provinceId;
                      });
                      _getDistrict();
                      _getMunicipality();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        h20,
        Text('District',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 80,
          child: DropdownButtonFormField<String>(
            menuMaxHeight: widget.isWideScreen?200:400.h,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            padding: EdgeInsets.zero,
            value: selectedDistrict,
            validator: (value){
              if(selectedDistrict == 'Select a District'){
                return 'Please select a District';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
            ),
            items:[DropdownMenuItem<String>(
              value: 'Select a District',
              child: Text(
                'Select a District',
                style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                overflow: TextOverflow.ellipsis,
              ),
            ),...districts
                .map(
                  (DistrictModel item) => DropdownMenuItem<String>(
                value: item.districtName,
                child: Text(
                  item.districtName,
                  style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList()],
            onChanged: (String? value) {
              setState(() {
                selectedDistrict = value!;
                districtId = districts.firstWhere(
                      (district) => district.districtName == value,
                  orElse: () => DistrictModel(districtId: 0, districtName: '', provinceId: 0, provinceName: ''),
                ).districtId;
              });
              _getMunicipality();
            },
          ),
        ),
        h20,
        Text('Municipality',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 80,
          child: DropdownButtonFormField<String>(
            menuMaxHeight: widget.isWideScreen?200:400.h,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            padding: EdgeInsets.zero,
            value: selectedMunicipality,
            validator: (value){
              if(selectedMunicipality == 'Select a Municipality'){
                return 'Please select a Municipality';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
            ),
            items:[DropdownMenuItem<String>(
              value: 'Select a Municipality',
              child: Text(
                'Select a Municipality',
                style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                overflow: TextOverflow.ellipsis,
              ),
            ),...municipalities
                .map(
                  (MunicipalityModel item) => DropdownMenuItem<String>(
                value: item.municipalityName,
                child: Text(
                  item.municipalityName,
                  style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList()],
            onChanged: (String? value) {
              setState(() {
                selectedMunicipality = value!;
                municipalityId = municipalities.firstWhere(
                      (municipality) => municipality.municipalityName == value,
                  orElse: () => MunicipalityModel(municipalityId: 0, municipalityName: '', districtId: 0, districtName: ''),
                ).municipalityId;
              });
            },
          ),
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ward No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
                  width: 180.w,
                  child: TextFormField(
                    controller: _wardController,
                    keyboardType: TextInputType.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'Ward no. is required';
                      }

                      if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                        return 'Please enter a valid Ward no.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                        hintText: 'Ward No.',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Local Address',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
                  width: 180.w,
                  child: TextFormField(
                    controller: _addressController,
                    keyboardType: TextInputType.text,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value){
                      if (value!.isEmpty) {
                        return 'Address is required';
                      }

                      if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                        return 'Please enter a valid Address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                        hintText: 'Local Address',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        )
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

      ],
    );
  }

  Column _register(){
    final selectImage = ref.watch(imageProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Department Details',style: getMediumStyle(color: ColorManager.black,fontSize: 22),),
            Container(
              width: 210,
              child: Divider(
                thickness: 0.5,
                color: ColorManager.black.withOpacity(0.5),
              ),
            )
          ],
        ),
        h20,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose a department',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 80,
                  width: 180,
                  child: DropdownButtonFormField<String>(
                    menuMaxHeight: widget.isWideScreen?200:400.h,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    padding: EdgeInsets.zero,
                    value: selectedDepartment,
                    validator: (value){
                      if(selectedDepartment == 'Select a Department'){
                        return 'Please select a Department';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                      ),
                    ),
                    items: [DropdownMenuItem<String>(
                      value: 'Select a Department',
                      child: Text(
                        'Select a Department',
                        style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?18.sp:18),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),...departments
                        .map(
                          (Department item) => DropdownMenuItem<String>(
                        value: item.departmentName,
                        child: Text(
                          item.departmentName,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?18.sp:18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList()],
                    onChanged: (String? value) {
                      setState(() {
                        selectedDepartment = value!;
                        departmentId = departments.firstWhere(
                              (department) => department.departmentName == value,
                          orElse: () => Department(departmentId: 0, departmentTypeID: 0, departmentName: '', departmentIcon: '', isActive: false, remarks: '', entryDate: DateTime.now() , flag: ''),
                        ).departmentId;
                      });
                    },
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Appointment Date',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  width: 180.w,
                  height: 60,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Date is required';
                      }

                      // Create a regular expression pattern to match 'yyyy-MM-dd' format
                      final pattern = r'^\d{4}-\d{2}-\d{2}$';
                      final regex = RegExp(pattern);

                      if (!regex.hasMatch(value)) {
                        return 'Invalid Date';
                      }

                      // Split the date string into parts
                      final dateParts = value.split('-');

                      // Ensure there are three parts (year, month, day)
                      if (dateParts.length != 3) {
                        return 'Invalid Date';
                      }

                      final year = int.tryParse(dateParts[0]);
                      final month = int.tryParse(dateParts[1]);
                      final day = int.tryParse(dateParts[2]);

                      if (year == null || month == null || day == null) {
                        return 'Invalid Date';
                      }

                      // Check if the month is invalid
                      if (month < 1 || month > 12) {
                        return 'Invalid Month';
                      }

                      // Check if the day is invalid for the selected month
                      if (day < 1 || day > DateTime(year, month + 1, 0).day) {
                        return 'Day must be between 1 and ${DateTime(year, month, 0).day}';
                      }

                      // Get the current date
                      final currentDate = DateTime.now();

                      // Check if the selected date is in the future
                      if (DateTime(year, month, day).isBefore(currentDate)) {
                        return 'Date cannot be in the past';
                      }

                      print(value);

                      return null;
                    },


                    inputFormatters: [
                      DateInputFormatter()
                    ],
                    controller: _consultController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.4)
                          )
                      ),
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,color: ColorManager.blue,),
                        onPressed: () => _selectDate(context, _consultController),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
        h20,
        Text('Choose a doctor',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 80,
          width: 380,
          child: DropdownButtonFormField<String>(
            menuMaxHeight: widget.isWideScreen?200:400.h,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            padding: EdgeInsets.zero,
            value: selectedDoctor,
            validator: (value){
              if(selectedDoctor == 'Select a Doctor'){
                return 'Please select a Doctor';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
              ),
            ),
            items: [DropdownMenuItem<String>(
              value: 'Select a Doctor',
              child: Text(
                'Select a Doctor',
                style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                overflow: TextOverflow.ellipsis,
              ),
            ),...doctors
                .map(
                  (User item) => DropdownMenuItem<String>(
                value: 'Dr. ${item.firstName} ${item.lastName}',
                child: Text(
                  'Dr. ${item.firstName} ${item.lastName}',
                  style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList()],
            onChanged: (String? value) {
              setState(() {
                selectedDoctor = value!;
                doctorId = doctors.firstWhere(
                      (user) => 'Dr. ${user.firstName} ${user.lastName}' == value,
                  orElse: () => User(),
                ).id;
              });
            },
          ),
        ),
        h20,
        Center(
          child:selectImage != null
              ? Container(
            height: 200,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: ColorManager.textGrey.withOpacity(0.1),
            ),
            padding: EdgeInsets.symmetric(vertical: 12.h,horizontal: 12.w),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.file(File(selectImage.path),width: 250,height: 150,),
                      h10,
                      Text('${selectImage.path}',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?14.sp:14),overflow: TextOverflow.fade,maxLines: 1,)
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: ()=>ref.invalidate(imageProvider),
                    child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorManager.textGrey.withOpacity(0.15)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 2.h),
                        child: FaIcon(Icons.close)),
                  ),
                )
              ],
            ),
          )
              :  DottedBorder(
            dashPattern: [16,6,16,4],
            color:imageSet == 2 ? ColorManager.red: ColorManager.textGrey,
            radius: Radius.circular(20),
            borderType: BorderType.RRect,
            child: InkWell(
              onTap: () async {
                 await showModalBottomSheet(

                   backgroundColor: ColorManager.white,
                     context: context,
                     builder: (context){
                       return Container(
                         height: 150,
                         padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           crossAxisAlignment: CrossAxisAlignment.center,
                           children: [
                             Column(
                               children: [
                                 InkWell(
                                   onTap : (){
                                     ref.read(imageProvider.notifier).camera();
                                     Navigator.pop(context);
                                   },
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       border: Border.all(
                                         color: ColorManager.black.withOpacity(0.5)
                                       )
                                     ),
                                     padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                     child: Icon(FontAwesomeIcons.camera,color: ColorManager.black,),
                                   ),
                                 ),
                                 h10,
                                 Text('Camera',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                               ],
                             ),
                             Column(
                               children: [
                                 InkWell(
                                   onTap:(){
                                     ref.read(imageProvider.notifier).pickAnImage();
                                     Navigator.pop(context);
                                   },
                                   child: Container(
                                     decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),
                                       border: Border.all(
                                         color: ColorManager.black.withOpacity(0.5)
                                       )
                                     ),
                                     padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 30.h),
                                     child: Icon(FontAwesomeIcons.image,color: ColorManager.black,),
                                   ),
                                 ),
                                 h10,
                                 Text('Gallery',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                               ],
                             ),
                           ],
                         ),
                       );
                     }
                 );
              },
              child: Container(
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorManager.textGrey.withOpacity(0.1),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.image,color: ColorManager.textGrey,),
                      h10,
                      Text('Please provide a image',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),)
                    ],
                  ),
                ),
              ),
            ),
          ),
        )

      ],
    );
  }

}
