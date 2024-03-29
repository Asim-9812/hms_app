


import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/data/provider/common_provider.dart';
import 'package:meroupachar/src/data/services/update_profile_service.dart';
import 'package:meroupachar/src/presentation/patient/profile/domain/model/patient_update_model.dart';
import 'package:meroupachar/src/presentation/patient/profile/domain/services/patient_update_services.dart';

import '../../../../../core/resources/value_manager.dart';
import '../../../../../data/model/country_model.dart';
import '../../../../../data/services/address_list_services.dart';
import '../../../../../data/services/country_services.dart';
import '../../../../common/date_input_formatter.dart';
import '../../../../common/snackbar.dart';
import '../../../../login/domain/model/user.dart';

class UpdatePatientProfile extends ConsumerStatefulWidget {

  final User user;
  UpdatePatientProfile({required this.user});

  @override
  ConsumerState<UpdatePatientProfile> createState() => _UpdatePatientProfileState();
}

class _UpdatePatientProfileState extends ConsumerState<UpdatePatientProfile> {

  late String token;


  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();

  final _lastNameController = TextEditingController();

  final _contactController = TextEditingController();

  final _wardController = TextEditingController();

  final _addressController = TextEditingController();

  final _ageController = TextEditingController();

  final _ageController2 = TextEditingController();

  final _dobController = TextEditingController();

  List<String> genderType = ['Select Gender','Male', 'Female', 'Others'];
  String? selectedGender;
  int? genderId ;

  List<String> ageType = ['years', 'months','days','hours'];
  String selectedAge = 'years';
  int ageId= 1;

  String countryName = 'NEPAL';
  String? address;
  int? districtId;
  int? municipalId;
  int? provinceId;
  int? countryId;
  bool isPostingData = false;


  List<ProvinceModel> provinces = [];
  List<MunicipalityModel> municipalities = [];
  List<DistrictModel> districts = [];

  String? age;
  String? gender;
  String? ageGender;


  @override
  void initState(){
    super.initState();

    token = widget.user.token ?? '';
    _getProvince();
    _firstNameController.text = widget.user.firstName! ;
    _lastNameController.text = widget.user.lastName! ;
    _contactController.text = widget.user.contactNo! ;
    _addressController.text = widget.user.localAddress ?? '';
    _wardController.text = widget.user.wardNo.toString();
    ageGender = widget.user.ageGender;
    selectedGender = ageGender?.split('/').last;
    genderId = genderType.indexOf(selectedGender??'Select Gender');
    if(widget.user.dob != null){
      _dobController.text = widget.user.dob!;
      _calculateAge();
    }
    municipalId = widget.user.municipalityID;
  }



  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:_dobController.text.isNotEmpty?DateFormat('yyyy-MM-dd').parse(_dobController.text): DateTime.now(),
      firstDate:DateTime(1900),
      lastDate:DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()){
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      _calculateAge();
    }


  }

  // Function to calculate DOB based on age
  void _calculateDOB() {
    final now = DateTime.now();
    if(ageId != 4){
      if(_ageController.text.isNotEmpty){

        final intAge = int.parse(_ageController.text);
        final ageInDays = ageId == 1 ? 365 * intAge : ageId == 2? 30 * intAge : intAge ;
        if(_ageController2.text.isNotEmpty){
          final intAge2 = int.parse(_ageController2.text);
          final ageInDays2 = ageId ==1 ? 30 *intAge2 : ageId == 2 ? intAge2 : 0;
          final totalAge = ageInDays + ageInDays2 ;
          final subtractDays = Duration(days: totalAge);
          DateTime date = now.subtract(subtractDays);
          _dobController.text = DateFormat('yyyy-MM-dd').format(date);
        }
        else{
          final subtractDays = Duration(days: ageInDays);
          DateTime date = now.subtract(subtractDays);
          _dobController.text = DateFormat('yyyy-MM-dd').format(date);
        }
      }
    }
    else{
      final intAge = int.parse(_ageController.text);
      final subHours = Duration(hours: intAge);
      final date = now.subtract(subHours);
      _dobController.text = DateFormat('yyyy-MM-dd').format(date);
    }

  }


  // Function to calculate age based on DOB
  void _calculateAge() {
    if (_dobController.text.isNotEmpty) {
      final now = DateTime.now();
      final dob = DateFormat('yyyy-MM-dd').parse(_dobController.text);
      final year = now.year - dob.year ;
      if(year <= 1){
        final month = now.month - dob.month ;
        if(month == 0){
          final days = now.day - dob.day ;
          if(days == 0){
            setState(() {
              ageId =4;
              selectedAge = 'hours';
            });
            int ageDifference = now.difference(dob).inHours;
            _ageController.text = ageDifference.toString();
            age = '${ageDifference}Hrs';

          }
          else {
            setState(() {
              ageId = 3;
              selectedAge = 'days';
            });
            Duration ageDuration = DateTime.now().difference(dob);

            int ageInDays = ageDuration.inDays;
            int remainingHours = (ageDuration.inHours % 24);

            _ageController.text = ageInDays.toString();
            _ageController2.text = remainingHours.toString();
            age = '${ageInDays}D.${remainingHours}H';


          }
        }
        else{
          setState(() {
            ageId = 2;
            selectedAge = 'months';
          });
          Duration ageDuration = DateTime.now().difference(dob);
          int ageInMonths = (ageDuration.inDays / 30).floor();
          int remainingDays = (ageDuration.inDays % 30).floor();
          _ageController.text = ageInMonths.toString();
          _ageController2.text = remainingDays.toString();
          age = '${ageInMonths}M.${remainingDays}D';
        }

      }else{
        setState(() {
          ageId = 1;
          selectedAge = 'years';
        });
        Duration ageDuration = DateTime.now().difference(dob);
        int ageInYears = (ageDuration.inDays / 365).floor();
        int remainingMonths = ((ageDuration.inDays % 365) / 30).floor();
        _ageController.text = ageInYears.toString();
        _ageController2.text = remainingMonths.toString();
        age = '${ageInYears}Y.${remainingMonths}M';

      }
    }
  }



  /// fetch province list...
  void _getProvince() async {
    List<ProvinceModel> provinceList = await CountryService().getAllProvince(token: token);

    setState(() {
      provinces = provinceList;
    });
    _getDistrict();
  }


  /// fetch district list...

  void _getDistrict() async {

    List<DistrictModel> districtList = await CountryService().getAllDistrict(token: token);

    setState(() {
      districts = districtList;
    });
    _getMunicipality();
  }


  /// fetch municipality list...

  void _getMunicipality() async {

    List<MunicipalityModel> municipalityList = await CountryService().getAllMunicipality(token: token);

    setState(() {
      municipalities = municipalityList;
    });

    _getAddress();


  }

  void _getAddress(){
    if(provinces.isNotEmpty && districts.isNotEmpty && municipalities.isNotEmpty){
      final getAddress = municipalities.firstWhere((element) => element.municipalityId == municipalId);
      final fullAddress = '${getAddress.municipalityName}(${getAddress.districtName})';
      setState(() {
        address = fullAddress;
      });
      print('address name : $address');
    }
  }







  @override
  Widget build(BuildContext context) {
    final addressProvider = ref.watch(getAddressList(token));
    final countryProvider = ref.watch(getCountries(token));
    final profilePicProvider= ref.watch(imageProvider);
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        // backgroundColor: ColorManager.white.withOpacity(0.9),
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          centerTitle: true,
          title: Text('Update Profile',style: getMediumStyle(color: ColorManager.white),),
          leading: IconButton(
              onPressed: ()=>Get.back(),
              icon: Icon(Icons.chevron_left,color: ColorManager.white,)),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  h10,
                  Center(
                    child: Stack(
                      children: [
                        Card(
                          elevation: 0,
                          shape: CircleBorder(
                            side: BorderSide(
                              color: ColorManager.black
                            )
                          ),
                          child: CircleAvatar(
                            radius: 60.r,
                            backgroundColor: ColorManager.white,
                            child: profilePicProvider != null ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  image: DecorationImage(image: FileImage(File(profilePicProvider.path)),fit: BoxFit.cover)
                                ), ) :
                                widget.user.profileImage != null ? Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      image: DecorationImage(image: FileImage(File(widget.user.profileImage!)),fit: BoxFit.cover)
                                  ), )
                                    :Icon(Icons.person,color: ColorManager.primary,),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 0,
                          child: GestureDetector(
                            onTap: ()async {
                              await showModalBottomSheet(
                                constraints: BoxConstraints(maxHeight: 150),
                                  context: context,
                                  builder: (context){
                                    return Container(
                                      color: ColorManager.white,
                                      padding: EdgeInsets.symmetric(vertical: 18),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                InkWell(
                                                  onTap : (){
                                                    ref.read(imageProvider.notifier).camera();


                                                    // if(image!=null){
                                                    //   // Convert XFile to File
                                                    //   File file2 = File(image.path);
                                                    //   PlatformFile platformFile = convertFileToPlatformFile(file2);
                                                    //
                                                    //   setState(() {
                                                    //     file = platformFile;
                                                    //     _validateFile =false;
                                                    //   });
                                                    //
                                                    //   ref.refresh(imageProvider);
                                                    //
                                                    // }


                                                    // Now you can work with the 'file' as a File
                                                    // For example, you can use it to display or upload the image
                                                    setState(() {

                                                    });
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
                                                  onTap:()async{

                                                    ref.read(imageProvider.notifier).pickAnImage();

                                                    // FilePickerResult? result = await FilePicker.platform.pickFiles(
                                                    //   allowMultiple: false,
                                                    //   type: FileType.custom,
                                                    //   allowedExtensions: [
                                                    //     'jpg',
                                                    //     'jpeg',
                                                    //     'png',
                                                    //     'gif',
                                                    //     'bmp',
                                                    //     'tiff',
                                                    //     'webp',
                                                    //     'svg',
                                                    //     'ico'],
                                                    // );
                                                    //
                                                    // if (result != null) {
                                                    //   setState(() {
                                                    //     file = result.files.first;
                                                    //     _validateFile =false;
                                                    //   });
                                                    //
                                                    // } else {
                                                    //   // User canceled the picker
                                                    // }

                                                    setState(() {

                                                    });
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
                                      ),
                                    );
                                  }
                              );
                            },
                            child: Container(
                              height: 36.h,
                              width: 36.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.r),
                                  border: Border.all(
                                      color: Colors.white,
                                      width: 2.w
                                  )
                              ),
                              child: Badge(
                                label: Icon(Icons.edit_outlined, color: Colors.white, size: 20.h,),
                                backgroundColor: ColorManager.primary,
                                largeSize: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  h20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorManager.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'First name',
                          ),
                          validator: (value){
                            if(value!.trim().isEmpty){
                              return 'First name is required';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      w10,
                      Expanded(
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorManager.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Last name',
                          ),
                          validator: (value){
                            if(value!.trim().isEmpty){
                              return 'Last name is required';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                    ],
                  ),
                  h20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _contactController,
                          decoration: InputDecoration(
                            filled: true,
                            // isDense: true,
                            fillColor: ColorManager.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            labelText: 'Phone number',
                          ),
                          validator: (value){
                            if(value!.trim().isEmpty){
                              return 'Number is required';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                      ),
                      w10,
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          isDense: true,
                          padding: EdgeInsets.zero,
                          value: selectedGender,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if(selectedGender == genderType[0] || selectedGender == null){
                              return 'Please select a Gender';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                            ),
                            labelText: 'Gender'
                          ),
                          items: genderType
                              .map(
                                (String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
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
                  // h20,
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     Expanded(
                  //       child: TextFormField(
                  //         controller: _ageController,
                  //         keyboardType: TextInputType.number,
                  //         autovalidateMode: AutovalidateMode.onUserInteraction,
                  //         onChanged: (value) {
                  //           setState(() {
                  //             _calculateDOB();
                  //           });
                  //         },
                  //         validator: (value){
                  //           if (value!.isEmpty) {
                  //             return 'Age is required';
                  //           }
                  //
                  //           if (!value.contains(RegExp(r'^\d+$'))) {
                  //             return 'Invalid age';
                  //           }
                  //           return null;
                  //         },
                  //         decoration: InputDecoration(
                  //           floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                  //           labelText: 'Age',
                  //           border: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //               borderSide: BorderSide(
                  //                   color: ColorManager.black
                  //               )
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     w10,
                  //     Expanded(
                  //       child: DropdownButtonFormField<String>(
                  //         isDense: true,
                  //         padding: EdgeInsets.zero,
                  //         value: selectedAge,
                  //         decoration: InputDecoration(
                  //           isDense: true,
                  //           filled: true,
                  //           fillColor: Colors.white,
                  //           border: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                  //           ),
                  //           enabledBorder: OutlineInputBorder(
                  //             borderRadius: BorderRadius.circular(10),
                  //             borderSide: BorderSide(color: ColorManager.black.withOpacity(0.5)),
                  //           ),
                  //         ),
                  //         items: ageType
                  //             .map(
                  //               (String item) => DropdownMenuItem<String>(
                  //             value: item,
                  //             child: Text(
                  //               item,
                  //               overflow: TextOverflow.ellipsis,
                  //             ),
                  //           ),
                  //         )
                  //             .toList(),
                  //         onChanged: (String? value) {
                  //           setState(() {
                  //             selectedAge = value!;
                  //             ageId = ageType.indexOf(value)+1;
                  //             _ageController2.clear();
                  //             _dobController.clear();
                  //             _ageController.clear();
                  //
                  //           });
                  //
                  //           print(ageId);
                  //         },
                  //       ),
                  //     ),
                  //     w10,
                  //     Expanded(
                  //       child: AbsorbPointer(
                  //         absorbing: ageId  >= ageType.length,
                  //         child: TextFormField(
                  //           controller: _ageController2,
                  //           keyboardType: TextInputType.number,
                  //           autovalidateMode: AutovalidateMode.onUserInteraction,
                  //           validator:(value){
                  //             if(ageId >= ageType.length){
                  //               return null;
                  //             }
                  //             if(value!.isEmpty){
                  //               return null;
                  //             }
                  //             if (!value.contains(RegExp(r'^\d+$'))) {
                  //               return 'Please enter a valid number';
                  //             }
                  //             else if(ageId == 1 && int.parse(value) >=13){
                  //               return 'Invalid month';
                  //             }
                  //             else if(ageId == 2 && int.parse(value) >=33){
                  //               return 'Invalid day';
                  //             }
                  //             else if(ageId == 3 && int.parse(value) >=25){
                  //               return 'Invalid hour';
                  //             }
                  //
                  //             return null;
                  //           },
                  //           onFieldSubmitted: (value) {
                  //             setState(() {
                  //               _calculateDOB();
                  //             });
                  //           },
                  //           decoration: InputDecoration(
                  //             floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                  //             labelText: ageId  >= ageType.length ? '-----' : ageType[ageId ],
                  //             border: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(10),
                  //                 borderSide: BorderSide(
                  //                     color: ColorManager.black
                  //                 )
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  h20,
                  TextFormField(
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
                      if (DateTime(year, month, day).isAfter(currentDate)) {
                        return 'Date cannot be in the future';
                      }


                      return null;
                    },
                    onFieldSubmitted: (value) {
                      setState(() {
                        _calculateAge();
                      });
                    },
                    inputFormatters: [
                      DateInputFormatter()
                    ],
                    controller: _dobController,
                    decoration: InputDecoration(
                      labelText: 'DOB',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.primary
                          )
                      ),
                      hintText: 'YYYY-MM-DD',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today,color: ColorManager.primary,),
                        onPressed: () => _selectDate(context, _dobController),
                      ),
                    ),
                  ),
                  h20,
                  countryProvider.when(
                      data: (data){
                        if(data.isEmpty){
                          return SizedBox();
                        }
                        else{
                          return DropdownSearch<String>(

                            items: data.map((e) => e.countryName).toList(),
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
                                  labelText: "Country",
                                  labelStyle: getRegularStyle(color: ColorManager.primary)
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                countryName = value!;
                              });
                              final selected = data.firstWhereOrNull((element) => element.countryName.contains(value!));
                              if(selected != null){
                                setState(() {
                                  countryId = selected.countryId;

                                });
                              }

                            },
                            validator: (value){

                              return null;
                            },
                            autoValidateMode: AutovalidateMode.onUserInteraction,


                            selectedItem:  countryName,
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
                              labelText: "Country",
                              labelStyle: getRegularStyle(color: ColorManager.primary)
                          ),
                        ),
                      ),
                      loading: ()=>DropdownSearch(
                        selectedItem: 'Loading',
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
                              labelText: "Country",
                              labelStyle: getRegularStyle(color: ColorManager.primary)
                          ),
                        ),
                      )
                  ),
                  h20,
                  if(countryName == 'NEPAL')
                    addressProvider.when(
                        data: (data){
                          if(data.isEmpty){
                            return SizedBox();
                          }
                          else{
                            return DropdownSearch<String>(

                              items: data.map((e) => e).toList(),
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
                                    labelText: "Address",
                                    labelStyle: getRegularStyle(color: ColorManager.primary)
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  address = value!;
                                });
                                // print(address);
                                // print(value!.split('(').first.toLowerCase().trim());
                                // print(value.split('(').last.split(')').first.toLowerCase().trim());

                                final selected = municipalities.firstWhereOrNull((element) => element.municipalityName.toLowerCase().trim() == value?.split('(').first.toLowerCase().trim() && element.districtName.toLowerCase().trim() == value?.split('(').last.split(')').first.toLowerCase().trim());
                                // final selected = municipalities.firstWhereOrNull((element) => element.municipalityName.toLowerCase().trim() == 'gokarneshwor' && element.districtName.toLowerCase().trim() == 'kathmandu');
                                if(selected != null){
                                  setState(() {
                                    municipalId = selected.municipalityId;
                                    districtId = selected.districtId;
                                    provinceId = districts.firstWhere((element) => element.districtId == districtId).provinceId;

                                  });
                                  print('$municipalId , $districtId , $provinceId');
                                }
                                else{
                                  print('no address set');
                                }

                              },
                              validator: (value){
                                if(value == null){
                                  return 'Please select an address';
                                }
                                return null;
                              },
                              autoValidateMode: AutovalidateMode.onUserInteraction,


                              selectedItem: address == null ? data.first : address,
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
                                labelText: "Address",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),
                        ),
                        loading: ()=>DropdownSearch(
                          selectedItem: 'Loading',
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
                                labelText: "Address",
                                labelStyle: getRegularStyle(color: ColorManager.primary)
                            ),
                          ),
                        )
                    ),
                  if(countryName == 'NEPAL')
                    h20,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: _wardController,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if (value!.trim().isEmpty) {
                              return 'Ward no. is required';
                            }

                            if (!value.contains(RegExp(r'^\d+$')))  {
                              return 'Invalid Ward No.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black.withOpacity(0.5)
                                )
                            ),
                            floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black
                                )
                            ),
                            labelText: 'Ward',
                            labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                          ),
                        ),
                      ),
                      w10,
                      Expanded(
                        child: TextFormField(
                          controller: _addressController,
                          keyboardType: TextInputType.text,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value){
                            if (value!.trim().isEmpty) {
                              return 'Address is required';
                            }

                            if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value))  {
                              return 'Please enter a valid Address';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black.withOpacity(0.5)
                                )
                            ),
                            floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                    color: ColorManager.black
                                )
                            ),
                            labelText: 'Local Address',
                            labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  h20,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.white,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',style: TextStyle(color: ColorManager.black),
                          ),
                        ),
                      ),
                      w10,
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed:isPostingData?null: ()async {
                            final scaffoldMessage = ScaffoldMessenger.of(context);
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                isPostingData = true;
                              });
                              UpdateProfileModel profileData = UpdateProfileModel(
                                  id: widget.user.id!,
                                  patientID: widget.user.username!,
                                  firstName: _firstNameController.text.trim(),
                                  lastName: _lastNameController.text.trim(),
                                  dob: _dobController.text.trim(),
                                  countryID: countryId??1,
                                  districtID: districtId ?? municipalities.first.districtId,
                                  ward: int.parse(_wardController.text.trim()),
                                  localAddress: _addressController.text.trim(),
                                  email: '',
                                  contact: _contactController.text.trim(),
                                  genderID: genderId!,
                                  entryDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                                  flag: '',
                                imagePhoto1: profilePicProvider != null ?File(profilePicProvider.path): widget.user.profileImage != null ? File(widget.user.profileImage!):null
                              );

                              final response = await PatientUpdateService().updateProfile(updateProfile: profileData,token: token);
                              if(response.isLeft()){
                                final leftValue = response.fold((l) => l, (r) => null);
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                    message: '$leftValue',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                                setState(() {
                                  isPostingData = false;
                                });
                              }
                              else{
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showSuccessSnackbar(
                                    message: 'Profile Updated',
                                    duration: const Duration(milliseconds: 1400),
                                  ),
                                );
                                User updateUser = User(
                                  userID: widget.user.userID,
                                  validDate: widget.user.validDate,
                                  entryDate: widget.user.entryDate,
                                  code: widget.user.code,
                                  isActive: widget.user.isActive,
                                  ageGender: age == null ? ageGender : '$age/$selectedGender',
                                  contactNo: _contactController.text.trim(),
                                  countryID: countryId,
                                  districtID: districtId,
                                  firstName: _firstNameController.text.trim(),
                                  lastName: _lastNameController.text.trim(),
                                  genderID: genderId,
                                  id: widget.user.id,
                                  email: widget.user.email,
                                  typeID: widget.user.typeID,
                                  provinceID: provinceId,
                                  municipalityID: municipalId,
                                  orgId: widget.user.orgId,
                                  joinedDate: widget.user.joinedDate,
                                  designation: widget.user.designation,
                                  flag: widget.user.flag,
                                  liscenceNo: widget.user.liscenceNo,
                                  localAddress: _addressController.text.trim(),
                                  natureID: widget.user.natureID,
                                  panNo: widget.user.panNo,
                                  parentID: widget.user.parentID,
                                  prefixSettingID: widget.user.prefixSettingID,
                                  password: widget.user.password,
                                  referredID: widget.user.referredID,
                                  profileImage: profilePicProvider?.path ?? widget.user.profileImage,
                                  roleID: widget.user.roleID,
                                  signatureImage: widget.user.signatureImage,
                                  token: widget.user.token,
                                  username: widget.user.username,
                                  wardNo: int.parse(_wardController.text.trim()),
                                  dob: _dobController.text.trim()


                                );

                                final userHive = Hive.box<User>('session');

                                userHive.putAt(0, updateUser);
                                setState(() {
                                  isPostingData = false;
                                });


                                Navigator.pop(context);

                              }

                            }



                          },
                          child:isPostingData? SizedBox(
                              height: 16,
                              child: SpinKitDualRing(color: ColorManager.white,size: 16,)): Text(
                            'Save',style: TextStyle(color: ColorManager.white),
                          ),
                        ),
                      ),

                    ],
                  ),
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
