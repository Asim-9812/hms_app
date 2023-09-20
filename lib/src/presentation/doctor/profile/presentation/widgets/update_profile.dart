


import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:medical_app/src/core/api.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/data/services/user_services.dart';
import 'package:medical_app/src/data/services/update_profile_service.dart';
import 'package:medical_app/src/presentation/login/domain/service/login_service.dart';

import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';
import '../../../../../data/model/country_model.dart';
import '../../../../../data/provider/common_provider.dart';
import '../../../../../data/services/country_services.dart';
import '../../../../common/snackbar.dart';
import '../../../../login/domain/model/user.dart';

class UpdateDocProfile extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final User user;
  UpdateDocProfile(this.isWideScreen,this.isNarrowScreen,this.user);

  @override
  ConsumerState<UpdateDocProfile> createState() => _UpdateDocProfileState();
}

class _UpdateDocProfileState extends ConsumerState<UpdateDocProfile> {

  List<String> genderType = ['Select Gender','Male', 'Female', 'Other'];
  String? selectedGender;
  int? genderId;
  final formKey = GlobalKey<FormState>();
  bool isPostingData = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _uhidController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _wardController = TextEditingController();

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




  @override
  void initState() {
    super.initState();

    _getCountry();
    _fillForm();

    genderId = widget.user.genderID ;
    ('gender $genderId');

    setState(() {
      selectedGender = genderId == 0 ? 'Select Gender' : genderId == 1? 'Male' : genderId == 2 ? 'Female':'Others';
    });


  }


  void _fillForm(){

    setState(() {
      _firstNameController.text = widget.user.firstName ?? '';
      _lastNameController.text = widget.user.lastName ?? '';
      _mobileController.text = widget.user.contactNo ?? '';
      _emailController.text = widget.user.email ?? '';
      _wardController.text = widget.user.wardNo.toString() ?? '';
      _addressController.text = widget.user.localAddress ?? '';
      _licenseController.text = widget.user.liscenceNo.toString() ?? '';
    });

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

  @override
  Widget build(BuildContext context) {
    final profileImg = ref.watch(imageProvider);
    final signatureImg = ref.watch(imageProvider2);
    ImageProvider<Object>? profileImage;

    if (profileImg != null) {
      profileImage = Image.file(File(profileImg.path)).image;
    } else if (widget.user.profileImage == null) {
      profileImage = AssetImage('assets/icons/user.png');
    } else {
      profileImage = NetworkImage('${Api.baseUrl}/${widget.user.profileImage}');
    }



    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.white,
        leading: IconButton(onPressed: ()=>Get.back(), icon: Icon(Icons.chevron_left,color: Colors.black,)),
        title: Text('Update your Profile',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen? 20.sp:24),),
        centerTitle: true,

      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 20.h),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: ColorManager.primaryDark,
                    fixedSize: Size.fromHeight(widget.isNarrowScreen?40.h:40)
                ),
                onPressed: isPostingData ? null :()async{
                  final now = DateTime.now();
                  final scaffoldMessage = ScaffoldMessenger.of(context);
                  if (formKey.currentState!.validate()){
                    setState(() {
                      isPostingData = true;
                    });

                    final response = await ref.read(userUpdateProvider).updateUser(
                        ID: widget.user.id!,
                        userID: widget.user.userID!,
                        typeID: 3,
                        referredID: 0,
                        parentID: 0,
                        firstName: _firstNameController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        password: '',
                        countryID: countryId!,
                        provinceID: provinceId!,
                        districtID: districtId!,
                        municipalityID: municipalityId!,
                        wardNo: int.parse(_wardController.text),
                        localAddress: _addressController.text.trim(),
                        genderID: genderId == null? 3 :genderId!,
                        contactNo: _mobileController.text.trim(),
                        email: _emailController.text.trim(),
                        roleID: 2,
                        designation: 'A',
                        joinedDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.user.joinedDate!)),
                        validDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.user.validDate!)),
                        signatureImage: 'signatureImage',
                        profileImage: 'profileImage',
                        isActive: true,
                        entryDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.user.entryDate!)),
                        PrefixSettingID: 1,
                        token: 'token',
                        flag: 'UPDATE',
                        profileImageUrl: profileImg,
                        signatureImageUrl: signatureImg,
                        liscenceNo:int.parse(_licenseController.text)
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
                      ref.refresh(userInfoProvider(widget.user.userID!));
                      Get.back();
                    }
                  }
                  else{
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showFailureSnackbar(
                        message: 'Please fill the required field',
                        duration: const Duration(milliseconds: 1400),
                      ),
                    );
                    setState(() {
                      isPostingData = false;
                    });
                  }
                },
                child: isPostingData? SpinKitDualRing(color: ColorManager.white,size: widget.isNarrowScreen?12.sp: 12,):Text('Save'),
              ),
            ),
            w10,
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    backgroundColor: ColorManager.dotGrey,
                    fixedSize: Size.fromHeight(widget.isNarrowScreen?40.h:40)
                ),
                onPressed: ()async{
                  ref.invalidate(userUpdateProvider);
                  setState(() {
                    isPostingData = false;
                  });
                  Get.back();
                },
                child: Text('Cancel',style: TextStyle(color: ColorManager.black),),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 1/5,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/containers/Tip-Container-3.png'),fit: BoxFit.cover),

              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    shape: CircleBorder(
                        side: BorderSide(
                            color: ColorManager.white,
                            width: 1
                        )
                    ),
                    child: CircleAvatar(
                      backgroundColor: ColorManager.white,
                      backgroundImage: profileImage,
                      radius: widget.isWideScreen? 40:40.r,
                    ),
                  ),
                  h10,
                  Builder(
                    builder: (context) {
                      return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )
                          ),
                          onPressed: ()async{
                            await showModalBottomSheet(
                              isDismissible: true,
                                context: context,
                                builder: (context){
                                  return Container(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.photo_library),
                                          title: Text('Pick from Gallery'),
                                          onTap: () {
                                             ref.read(imageProvider.notifier).pickAnImage();
                                            Navigator.pop(context); // Close the bottom sheet after selection
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.camera_alt),
                                          title: Text('Capture from Camera'),
                                          onTap: () {
                                           ref.read(imageProvider.notifier).camera();
                                            Navigator.pop(context); // Close the bottom sheet after selection
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }
                            );
                          },
                          child: Text('Update Profile Picture',style: getRegularStyle(color: ColorManager.black,fontSize: widget.isWideScreen? 14:14.sp),)
                      );
                    }
                  )
                ],
              ),
            ),
            h20,
            _buildUpdate(),
            h100,

          ],
        ),
      ),
    );
  }

  Widget _buildUpdate(){
    final selectImage = ref.watch(imageProvider2);
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
                          hintText:'Enter first name',
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
                          hintText:'Enter last name',
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
                      Text('Gender',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
                      h10,
                      Container(
                        height: 60,
                        width: 180.w,
                        child: DropdownButtonFormField<String>(
                          padding: EdgeInsets.zero,
                          value: selectedGender,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (selectedGender == genderType[0]) {
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
                                style: getRegularStyle(
                                  color: Colors.black,
                                  fontSize: widget.isNarrowScreen ? 20.sp : 20,
                                ),
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile No.',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
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
              Text('License No',style: getMediumStyle(color: ColorManager.black,fontSize: widget.isNarrowScreen?18.sp:18),),
              h10,
              Container(
                height: 60,
                width: 400.w,
                child: TextFormField(
                  controller: _licenseController,
                  keyboardType: TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'License number is required';
                    }

                    if (RegExp(r'^(?=.*?[A-Z])').hasMatch(value)||RegExp(r'^(?=.*?[a-z])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                      return 'Please enter a valid License Number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                    hintText: 'License Number',
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
                width: 400.w,
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
                width: 400.w,
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
                          onTap: ()=>ref.invalidate(imageProvider2),
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
                                          ref.read(imageProvider2.notifier).camera();
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
                                          ref.read(imageProvider2.notifier).pickAnImage();
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
                            Text('Provide a signature image',style: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }

}
