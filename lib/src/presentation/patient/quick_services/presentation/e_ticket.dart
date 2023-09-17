


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
import 'package:medical_app/src/presentation/login/domain/model/user.dart';
import 'package:medical_app/src/presentation/patient/quick_services/domain/services/cost_category_services.dart';
import 'package:medical_app/src/presentation/patient/quick_services/domain/services/patient_registration_service.dart';

import '../../../../core/resources/style_manager.dart';
import '../../../../data/services/user_services.dart';
import '../../../common/snackbar.dart';
import '../domain/model/cost_category_model.dart';

class ETicket extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  ETicket(this.isWideScreen,this.isNarrowScreen);

  @override
  ConsumerState<ETicket> createState() => _ETicketState();
}

class _ETicketState extends ConsumerState<ETicket> {
  List<String> genderType = ['Select Gender','Male', 'Female', 'Other'];
  String selectedGender = 'Select Gender';
  int genderId = 0;
  final formKey = GlobalKey<FormState>();
  bool isPostingData = false;

  DateTime? selectedDOB;
  DateTime? selectedDate;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _uhidController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _policyController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  List<Country> countries = [];
  int? countryId;
  String? selectedCountry;

  List<ProvinceModel> provinces = [];
  int? provinceId;
  String? selectedProvince;

  List<DistrictModel> districts = [];
  int? districtId;
  String? selectedDistrict;


  List<MunicipalityModel> municipalities = [];
  int? municipalityId;
  String? selectedMunicipality;



  List<CostCategoryModel> costCategory = [];
  int? costId ;
  String? selectedCategory;


  List<Department> departments = [];
  int? departmentId ;
  String? selectedDepartment;

  List<User> doctors = [];
  int? doctorId ;
  String? selectedDoctor;



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
      selectedProvince = provinces.isNotEmpty ? provinces[0].provinceName : 'Select a Province';
      provinceId = provinces.isNotEmpty ? provinces[0].provinceId : 0;

    });
    _getDistrict();
  }


  /// fetch district list...

  void _getDistrict() async {

    List<DistrictModel> districtList = await CountryService().getDistrict(provinceId: provinceId!);
    setState(() {
      districts = districtList;
      selectedDistrict = districts.isNotEmpty ? districts[0].districtName : 'Select a District';
      districtId = districts.isNotEmpty ? districts[0].districtId : 0;
    });
    _getMunicipality();
  }


  /// fetch municipality list...

  void _getMunicipality() async {

    List<MunicipalityModel> municipalityList = await CountryService().getMunicipality(districtId: districtId!);
    setState(() {
      municipalities = municipalityList;
      selectedMunicipality = municipalities.isNotEmpty ? municipalities[0].municipalityName : 'Select a Municipality';
      municipalityId = municipalities.isNotEmpty ? municipalities[0].municipalityId : 0;
    });
  }

  ///fetch cost category list...
  void _getCostCategory() async {
    List<CostCategoryModel> costCategoryList = await CostCategoryServices().getCostCategoryList();
    setState(() {
      costCategory = costCategoryList;
      costId =costCategory.isNotEmpty ? costCategory[0].costCategoryID  : 0;
      selectedCategory = costCategory.isNotEmpty ? costCategory[0].costCategoryType : 'Select a category';

    });
  }


  ///fetch department list...
  void _getDepartment() async {
    List<Department> departmentList = await DepartmentServices().getDoctorDepartments();
    setState(() {
      departments = departmentList;
      departmentId =departments.isNotEmpty ? departments[0].departmentId  : 0;
      selectedDepartment = departments.isNotEmpty ? departments[0].departmentName : 'Select a Department';

    });
  }


  ///fetch all doctor list...
  void _getDoctors() async {
    List<User> doctorList = await UserService().getDoctors();
    setState(() {
      doctors = doctorList;
      doctorId =doctors.isNotEmpty ? doctors[0].id  : 0;
      selectedDoctor = doctors.isNotEmpty ? 'Dr. ${doctors[0].firstName} ${doctors[0].lastName}' : 'Select a Doctor';

    });
  }




  Future<void> _selectDOB(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDOB ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDOB) {
      setState(() {
        selectedDOB = picked;
      });
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    final image = ref.watch(imageProvider);
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
          title: Text('Register',style: getMediumStyle(color: ColorManager.white),),
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
              if(image == null){
                scaffoldMessage.showSnackBar(
                  SnackbarUtil.showFailureSnackbar(
                    message: 'Please provide a image',
                    duration: const Duration(milliseconds: 1400),
                  ),
                );
              }
              else{
                if(selectedDate== null || selectedDOB == null){
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showFailureSnackbar(
                      message: 'Please fill in the date',
                      duration: const Duration(milliseconds: 1400),
                    ),
                  );
                }else if(selectedDate!.isBefore(now) || selectedDate!.day == now.day && selectedDate!.month == now.month && selectedDate!.year == now.year){
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showFailureSnackbar(
                      message: 'Appointment date is not valid.',
                      duration: const Duration(milliseconds: 1400),
                    ),
                  );
                }else{
                  if (formKey.currentState!.validate()){
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
                        code: 'RPC'
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
                }

              }
            },
            child: isPostingData? SpinKitDualRing(color: ColorManager.white,size: widget.isNarrowScreen?12.sp: 12,):Text('Submit'),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Cost Category',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
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
                    items: costCategory
                        .map(
                          (CostCategoryModel item) => DropdownMenuItem<String>(
                        value: item.costCategoryType,
                        child: Text(
                          item.costCategoryType,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
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

            if(selectedCategory != 'General')
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Policy No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
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
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DOB',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18 ),),
                h10,
                InkWell(
                  onTap: () => _selectDOB(context),
                  child: Container(
                    height: 55,
                    width: 180.w,
                    margin: EdgeInsets.only(bottom: 5),
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ColorManager.black,
                        width: 0.5,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        selectedDOB == null
                            ? 'Pick a date'
                            : DateFormat('yyyy-MM-dd').format(selectedDOB!),
                        style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?20.sp:20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Moblie No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                h10,
                Container(
                  height: 60,
                  width: 180.w,
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
              ],
            ),
          ],
        ),
        h20,
        Text('Gender',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 60,
          width: 380.w,
          child: DropdownButtonFormField<String>(

            padding: EdgeInsets.zero,
            value: selectedGender,
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
        h20,
        Text('Email',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 60,
          width: 380.w,
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
                  height: 60,
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
                  height: 60,
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
                    items: provinces.where((element) => element.countryId == countryId)
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
                        .toList(),
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
          height: 60,
          width: 380.w,
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
            items:districts
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
                .toList(),
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
          height: 60,
          width: 380.w,
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
            items:municipalities
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
                .toList(),
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
                  height: 60,
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
                    items: departments
                        .map(
                          (Department item) => DropdownMenuItem<String>(
                        value: item.departmentName,
                        child: Text(
                          item.departmentName,
                          style: getRegularStyle(color: Colors.black,fontSize: widget.isNarrowScreen?20.sp:20),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                        .toList(),
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
                  height: 60,
                  width: 180,
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      height: 55,
                      width: 180,
                      margin: EdgeInsets.only(bottom: 5),
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: ColorManager.black,
                          width: 0.5,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedDate == null
                              ? 'Date for consultation'
                              : DateFormat('yyyy-MM-dd').format(selectedDate!),
                          style: getRegularStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?20.sp:20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        h20,
        Text('Choose a doctor',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
        h10,
        Container(
          height: 60,
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
            items: doctors
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
                .toList(),
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
            color: ColorManager.textGrey,
            radius: Radius.circular(20),
            borderType: BorderType.RRect,
            child: InkWell(
              onTap: ()  {
                 ref.read(imageProvider.notifier).pickAnImage();
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
