import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:meroupachar/src/core/api.dart';
import 'package:meroupachar/src/data/provider/common_provider.dart';
import 'package:meroupachar/src/data/services/address_list_services.dart';
import 'package:meroupachar/src/data/services/country_services.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../../core/resources/color_manager.dart';
import '../../../../../core/resources/style_manager.dart';
import '../../../../../core/resources/value_manager.dart';
import '../../../../../data/model/country_model.dart';
import '../../../../../data/services/update_profile_service.dart';
import '../../../../../data/services/user_services.dart';
import '../../../../common/snackbar.dart';
import '../../../../login/domain/model/user.dart';

class UpdateOrgProfile extends ConsumerStatefulWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  final User user;
  UpdateOrgProfile(this.isWideScreen, this.isNarrowScreen, this.user);

  @override
  ConsumerState<UpdateOrgProfile> createState() => _UpdateOrgProfileState();
}

class _UpdateOrgProfileState extends ConsumerState<UpdateOrgProfile> {
  late User user;
  String? tempProfileImage; // Variable to store temporary changes
  String? tempSignImage;
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




  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _panController = TextEditingController();
  TextEditingController _localController = TextEditingController();
  TextEditingController _wardController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = widget.user;

    tempProfileImage = user.profileImage == null ? null :user.profileImage!;
    tempSignImage = user.signatureImage == null ? null :user.signatureImage!;
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
    _numberController.text = user.contactNo ?? '';
    _panController.text = user.panNo.toString();
    _localController.text = user.localAddress ?? '';
    _wardController.text = user.wardNo.toString();
    countryId = user.countryID;
    districtId = user.districtID;
    provinceId = user.provinceID;
    municipalId = user.municipalityID;
    _getProvince();
  }



  /// fetch province list...
  void _getProvince() async {
    List<ProvinceModel> provinceList = await CountryService().getAllProvince();

    setState(() {
      provinces = provinceList;
    });
    _getDistrict();
  }


  /// fetch district list...

  void _getDistrict() async {

    List<DistrictModel> districtList = await CountryService().getAllDistrict();

    setState(() {
      districts = districtList;
    });
    _getMunicipality();
  }


  /// fetch municipality list...

  void _getMunicipality() async {

    List<MunicipalityModel> municipalityList = await CountryService().getAllMunicipality();

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

  // ... (other methods)

  @override
  Widget build(BuildContext context) {
    final profileProvider = ref.watch(imageProvider);
    final signatureProvider = ref.watch(imageProvider2);
    final addressProvider = ref.watch(getAddressList);
    final countryProvider = ref.watch(getCountries);
    print(user.profileImage);

    return WillPopScope(
      onWillPop: () async {
        ref.invalidate(imageProvider);
        ref.invalidate(imageProvider2);
        return true;
      },
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: ColorManager.primary,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                ref.invalidate(imageProvider);
                ref.invalidate(imageProvider2);
                Get.back();
              },
              icon: Icon(Icons.chevron_left, color: Colors.white),
            ),
            title: Text(
              'Update your Profile',
              style: getMediumStyle(color: ColorManager.white, fontSize: 20),
            ),
          ),
          bottomNavigationBar: Row(
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
                    ref.invalidate(imageProvider);
                    ref.invalidate(imageProvider2);
                    Get.back();
                  },
                  child: Text(
                    'Cancel',
                    style: getRegularStyle(
                        color: ColorManager.black,
                        fontSize: widget.isWideScreen ? 24 : 24.sp),
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
                  onPressed: () async {
                     final now = DateTime.now();
                     final scaffoldMessage = ScaffoldMessenger.of(context);
                     if (_formKey.currentState!.validate()){
                       setState(() {
                         isPostingData = true;
                       });

                       final response = await ref.read(userUpdateProvider).updateUser(
                           ID: user.id!,
                           userID: user.userID!,
                           typeID: user.typeID!,
                           referredID: user.referredID!,
                           parentID: user.parentID!,
                           firstName: _firstNameController.text.trim(),
                           lastName: _lastNameController.text.trim(),
                           password: '',
                           countryID: countryId!,
                           provinceID: provinceId!,
                           districtID: districtId!,
                           municipalityID: municipalId!,
                           wardNo: int.parse(_wardController.text),
                           localAddress: _localController.text.trim(),
                           genderID: user.genderID!,
                           contactNo: _numberController.text.trim(),
                           email: user.email!,
                           roleID: user.roleID!,
                           designation: user.designation!,
                           joinedDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(user.joinedDate!)),
                           validDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                           signatureImage: 'signatureImage',
                           profileImage: 'profileImage',
                           isActive: user.isActive!,
                           entryDate: DateFormat('yyyy-MM-dd').format(DateTime.parse(user.entryDate!)),
                           PrefixSettingID: user.prefixSettingID!,
                           token: user.token!,
                           flag: 'UPDATE',
                           profileImageUrl: profileProvider == null ? tempProfileImage == null? null : XFile('${Api.baseUrl}/${user.profileImage}'): profileProvider ,
                           signatureImageUrl: signatureProvider == null ? tempSignImage == null? null : XFile('${Api.baseUrl}/${user.signatureImage}'): signatureProvider,
                           panNo:int.parse(_panController.text)
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
                             message: 'Successfully Updated',
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
                           message: 'Please fill a valid form',
                           duration: const Duration(milliseconds: 1400),
                         ),
                       );
                       setState(() {
                         isPostingData = false;
                       });
                     }
                   },
                  child: Text(
                    'Save',
                    style: getRegularStyle(
                        color: ColorManager.white,
                        fontSize: widget.isWideScreen ? 24 : 24.sp),
                  ),
                ),
              ),

            ],
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    h20,
                    Center(
                      child: Card(
                        shape: CircleBorder(
                            side: BorderSide(color: ColorManager.black, width: 1)),
                        child: CircleAvatar(
                          backgroundColor: ColorManager.white,
                          backgroundImage: profileProvider != null
                              ? Image.file(File(profileProvider.path)).image
                              : tempProfileImage == null
                              ? null
                              : NetworkImage(
                              '${Api.baseUrl}/${widget.user.profileImage}'),
                          radius: widget.isWideScreen ? 60 : 60.r,
                          child: profileProvider != null
                              ? null
                              : tempProfileImage == null
                              ? Icon(FontAwesomeIcons.user, color: ColorManager.black)
                              : null,
                        ),
                      ),
                    ),
                    h10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              builder: (context) {
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
                                          if (profileProvider != null) {
                                            setState(() {
                                              tempProfileImage = profileProvider.path;
                                            });
                                          }

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Capture from Camera'),
                                        onTap: () {
                                          ref.read(imageProvider.notifier).camera();
                                          if (profileProvider != null) {
                                            setState(() {
                                              tempProfileImage = profileProvider.path;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Update Profile Picture',
                            style: getRegularStyle(
                                color: ColorManager.white,
                                fontSize: widget.isWideScreen ? 14 : 14.sp),
                          ),
                        ),
                        // w10,
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: ColorManager.white,
                        //     elevation: 5,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     if (user.profileImage != null) {
                        //       setState(() {
                        //         tempProfileImage = null;
                        //       });
                        //     }
                        //     ref.invalidate(imageProvider);
                        //   },
                        //   child: Text(
                        //     'Remove Profile Picture',
                        //     style: getRegularStyle(
                        //         color: ColorManager.black,
                        //         fontSize: widget.isWideScreen ? 14 : 14.sp),
                        //   ),
                        // ),
                      ],
                    ),
                    h20,
                    TextFormField(
                      controller: _firstNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value!.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                          return 'Invalid Name. Only use letters';
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
                        hintText:'Enter name',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        labelText: 'Name',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      ),
                    ),
                    h20,
                    TextFormField(
                      controller: _lastNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value!.trim().isEmpty) {
                          return 'Name is required';
                        }
                        if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                          return 'Invalid Name. Only use letters';
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
                        hintText:'Enter name',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        labelText: 'Mailing Name',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                      ),
                    ),
                    h20,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                fillColor: ColorManager.dotGrey.withOpacity(0.5),
                                filled: true,
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
                                labelText: 'Email',
                                labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        w10,
                        Expanded(
                          child: TextFormField(
                            controller: _numberController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if (value!.trim().isEmpty) {
                                return 'Number is required';
                              }
                              if (value.length < 7 ) {
                                return 'Invalid Number';
                              }
                              if (!value.contains(RegExp(r'^\d+$')))  {
                                return 'Invalid Number';
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
                              hintText:'Enter number',
                              hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: ColorManager.black
                                  )
                              ),
                              labelText: 'Contact no.',
                              labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    h20,
                    TextFormField(
                      controller: _panController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value){
                        if (value!.trim().isEmpty) {
                          return 'PAN Number is required';
                        }
                        if (value.length < 9 || value.length > 9 ) {
                          return 'Invalid PAN Number';
                        }

                        if (!value.contains(RegExp(r'^\d+$')))  {
                          return 'Invalid PAN Number';
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
                        hintText:'Enter PAN number',
                        hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        labelText: 'PAN no.',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 16),
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


                              selectedItem: user.countryID == null ? countryName : data.firstWhere((element) => element.countryId == user.countryID).countryName,
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
                                print(address);
                                print(value!.split('(').first.toLowerCase().trim());
                                print(value.split('(').last.split(')').first.toLowerCase().trim());

                               final selected = municipalities.firstWhereOrNull((element) => element.municipalityName.toLowerCase().trim() == value.split('(').first.toLowerCase().trim() && element.districtName.toLowerCase().trim() == value.split('(').last.split(')').first.toLowerCase().trim());
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
                              hintText: 'Ward No.',
                              hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
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
                            controller: _localController,
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
                              hintText: 'Local Address',
                              hintStyle: getRegularStyle(color: ColorManager.textGrey,fontSize: widget.isNarrowScreen?20.sp:20),
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
                    Center(
                      child: Card(

                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: ColorManager.black,
                            width: 1
                          )
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorManager.dotGrey.withOpacity(0.05),
                            image: signatureProvider != null
                                ? DecorationImage(image: Image.file(File(signatureProvider.path)).image,fit: BoxFit.cover,filterQuality: FilterQuality.high)
                                : tempSignImage == null
                                ? null
                                : DecorationImage(
                                image : NetworkImage('${Api.baseUrl}/${widget.user.signatureImage}'),fit: BoxFit.cover,filterQuality: FilterQuality.high),
                          ),

                          child: signatureProvider != null
                              ? null
                              : tempSignImage == null
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.signature, color: ColorManager.black.withOpacity(0.7)),
                                  h10,
                                  Text('Add a Signature',style: getMediumStyle(color: ColorManager.black.withOpacity(0.7),fontSize: 20,),)
                                ],
                              )
                              : null,
                        ),
                      ),
                    ),
                    h10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primary,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            await showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              builder: (context) {
                                return Container(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Icons.photo_library),
                                        title: Text('Pick from Gallery'),
                                        onTap: () {
                                          ref.read(imageProvider2.notifier).pickAnImage();
                                          if (signatureProvider != null) {
                                            setState(() {
                                              tempSignImage = signatureProvider.path;
                                            });
                                          }

                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.camera_alt),
                                        title: Text('Capture from Camera'),
                                        onTap: () {
                                          ref.read(imageProvider2.notifier).camera();
                                          if (signatureProvider != null) {
                                            setState(() {
                                              tempSignImage = signatureProvider.path;
                                            });
                                          }
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Update Signature Picture',
                            style: getRegularStyle(
                                color: ColorManager.white,
                                fontSize: widget.isWideScreen ? 14 : 14.sp),
                          ),
                        ),
                        // w10,
                        // ElevatedButton(
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: ColorManager.white,
                        //     elevation: 5,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //   ),
                        //   onPressed: () {
                        //     if (user.signatureImage != null) {
                        //       setState(() {
                        //         tempSignImage = null;
                        //       });
                        //     }
                        //     ref.invalidate(imageProvider2);
                        //   },
                        //   child: Text(
                        //     'Remove Signature Picture',
                        //     style: getRegularStyle(
                        //         color: ColorManager.black,
                        //         fontSize: widget.isWideScreen ? 14 : 14.sp),
                        //   ),
                        // ),
                      ],
                    ),
                    h20,
                    h100,
                    h100

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Function to convert network image to XFile
}
