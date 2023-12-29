



import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/presentation/register/domain/checkEmailCode/check_service.dart';
import 'package:meroupachar/src/presentation/register/domain/register_model/register_model.dart';
import 'package:meroupachar/src/presentation/register/domain/register_service.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';
import '../../subscription-plan/presentation/subscription_plan_doctor.dart';

class RegisterDoctor extends ConsumerStatefulWidget {
  final int accountId;
  RegisterDoctor({required this.accountId});

  @override
  ConsumerState<RegisterDoctor> createState() => _RegisterOrganizationState();
}

class _RegisterOrganizationState extends ConsumerState<RegisterDoctor> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  int natureId = 0;
  List<String> professionType = ['Select Profession Type','Doctor', 'Admin', 'Account'];
  List<String> genderType = ['Select Gender','Male', 'Female'];


  String selectedProfession = 'Select Nature Type';
  String selectedGender = 'Select Gender';
  int genderId = 0;


  bool _obscureText = true ;
  bool _obscureText2 = true ;
  bool _isChecked = false;

  bool isPostingData = false;

  final dio =Dio();

  RegisterDoctorModel? registerDoctorModel;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return ColorManager.primary;
  }

  Map<String,dynamic> outputValue = {};



  @override
  Widget build(BuildContext context) {
    return _buildProfessional();
  }

  Widget _buildProfessional() {
    final natureType = ref.watch(getNatureType);
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: 18.h,
          ),


          natureType.when(
              data: (data){
                return DropdownButtonFormField<String>(
                  validator: (value){
                    if(selectedProfession == 'Select Nature Type'){
                      return 'Please select a Nature Type';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedProfession,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    labelText: 'Nature Type',
                    labelStyle: getRegularStyle(color: ColorManager.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  items: [DropdownMenuItem(
                      value: 'Select Nature Type',
                      child: Text(
                        'Select Nature Type',
                        style: getRegularStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      )),...data
                      .map(
                        (NatureTypeModel item) => DropdownMenuItem<String>(
                      value: item.natureType,
                      child: Text(
                        item.natureType,
                        style: getRegularStyle(color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                      .toList()],
                  onChanged: (String? value) {
                    setState(() {
                      selectedProfession = value!;
                      natureId = data.firstWhere((element) => element.natureType == value).typeID;
                    });
                  },
                );
              },
              error: (error,stack) => DropdownButtonFormField<String>(
                value: 'Something went wrong',
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.black.withOpacity(0.5)
                      )
                  ),
                  labelText: 'Nature Type',
                  labelStyle: getRegularStyle(color: ColorManager.primary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: [], onChanged: (String? value) {  },

              ),
              loading: ()=>DropdownButtonFormField<String>(
                value: 'Loading',
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.black.withOpacity(0.5)
                      )
                  ),
                  labelText: 'Nature Type',
                  labelStyle: getRegularStyle(color: ColorManager.primary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                items: [], onChanged: (String? value) {  },

              ),
          ),



          SizedBox(
            height: 18.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'First Name is required';
                    }
                    if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                      return 'Invalid Name';
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
                      labelText: 'First Name',
                      labelStyle: getRegularStyle(color: ColorManager.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black
                          )
                      )
                  ),
                ),
              ),
              w10,
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Last Name is required';
                    }
                    if (RegExp(r'^(?=.*?[0-9])').hasMatch(value)||RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                      return 'Invalid Name';
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
                      labelText: 'Last Name',
                      labelStyle: getRegularStyle(color: ColorManager.black),
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
          //
          // h20,
          // TextFormField(
          //   controller: _licenseController,
          //   autovalidateMode: AutovalidateMode.onUserInteraction,
          //   validator: (value){
          //     if (value!.isEmpty) {
          //       return 'License is required';
          //     }
          //     return null;
          //   },
          //   decoration: InputDecoration(
          //       focusedBorder: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           borderSide: BorderSide(
          //               color: ColorManager.black.withOpacity(0.5)
          //           )
          //       ),
          //       floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
          //       labelText: 'License No.',
          //       labelStyle: getRegularStyle(color: ColorManager.black),
          //       border: OutlineInputBorder(
          //           borderRadius: BorderRadius.circular(10),
          //           borderSide: BorderSide(
          //               color: ColorManager.black
          //           )
          //       )
          //   ),
          // ),
          h20,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: DropdownButtonFormField<String>(
                  isDense: true,
                  validator: (value){
                    if(selectedGender == genderType[0]){
                      return 'Please select a Gender';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  value: selectedGender,
                  decoration: InputDecoration(
                    isDense: true,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: ColorManager.black.withOpacity(0.5)
                        )
                    ),
                    labelText: 'Select Gender',
                    labelStyle: getRegularStyle(color: ColorManager.primary),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  items: genderType
                      .map(
                        (String item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: getRegularStyle(color: Colors.black),
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
              w10,
              Expanded(
                child: TextFormField(
                  controller: _codeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 2 && value.length > 6 ) {
                      return 'Invalid';
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
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                      floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                      labelText: 'Code',
                      labelStyle: getRegularStyle(color: ColorManager.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black
                          )
                      )
                  ),
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(6)
                  ],
                ),
              ),
            ],
          ),

          SizedBox(
            height: 18.h,
          ),

          Row(
            children: [
              Expanded(
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
                    if (value.indexOf('@') != value.lastIndexOf('@')) {
                      return 'Email should contain only one "@" symbol';
                    }
                    if (!value.contains('.')) {
                      return 'Email should contain a domain extension';
                    }
                    if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[a-zA-Z]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    if (value.contains('__')) {
                      return 'Only one underscore "_" is allowed';
                    }
                    if (value.length > 50) {
                      return 'Email length must be 50 characters or less';
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
                      labelText: 'E-mail',
                      labelStyle: getRegularStyle(color: ColorManager.black),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black
                          )
                      )
                  ),
                ),
              ),
              w10,
              Expanded(
                child: TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.number,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Mobile number is required';
                    }
                    if (value.length!=10) {
                      return 'Enter a valid number';
                    }
                
                    if (!value.contains(RegExp(r'^\d+$')))  {
                      return 'Please enter a valid Mobile Number';
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
                    labelText: 'Mobile Number',
                    labelStyle: getRegularStyle(color: ColorManager.black),
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

          SizedBox(
            height: 18.h,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 6) {
                return 'Enter minimum 6 characters';
              }
              if (value.contains(' ')) {
                return 'Do not enter spaces';
              }
              if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                return 'Enter at least one uppercase letter';
              }
              if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
                return 'Enter at least one lowercase letter';
              }
              if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                return 'Enter at least one Digit';
              }
              if (!RegExp(r'^(?=.*?[!@#&*~])').hasMatch(value)) {
                return 'Enter at least one special character';
              }
              return null;
            },
            controller: _passController,
            obscureText: _obscureText,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                labelText: 'Password',
                labelStyle: getRegularStyle(color: ColorManager.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.black
                    )
                ),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: _obscureText? FaIcon(CupertinoIcons.eye,color: ColorManager.black,):FaIcon(CupertinoIcons.eye_slash,color: ColorManager.black,),
                )
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Confirm Password is required';
              } else if(value != _passController.text.trim()){
                return 'Password doesnt match';
              }
              return null;
            },
            controller: _passConfirmController,
            obscureText: _obscureText2,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
                floatingLabelStyle: getRegularStyle(color: ColorManager.primary),
                labelText: 'Confirm Password',
                labelStyle: getRegularStyle(color: ColorManager.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.black
                    )
                ),
                suffixIcon: IconButton(
                  onPressed: (){
                    setState(() {
                      _obscureText2 = !_obscureText2;
                    });
                  },
                  icon: _obscureText2? FaIcon(CupertinoIcons.eye,color: ColorManager.black,):FaIcon(CupertinoIcons.eye_slash,color: ColorManager.black,),
                )
            ),
          ),

          SizedBox(
            height: 18.h,
          ),
          ElevatedButton(
            onPressed: () async {
              if(formKey.currentState!.validate()){
                setState(() {
                  isPostingData = true;
                });
                final scaffoldMessage = ScaffoldMessenger.of(context);

                final response = await ref.read(checkProvider).checkEmail(
                    email: _emailController.text.trim()
                );

                if (response.isLeft()) {
                  final leftValue = response.fold(
                        (left) => left,
                        (right) => '', // Empty string here as we are only interested in the left value
                  );

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
                  final codeResponse = await ref.read(checkProvider).checkCode(
                      code: _codeController.text.trim()
                  );
                  if (codeResponse.isLeft()) {
                    final leftValue = codeResponse.fold(
                          (left) => left,
                          (right) => '', // Empty string here as we are only interested in the left value
                    );

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
                    registerDoctorModel = RegisterDoctorModel(
                        // licenseNo:_licenseController.text.trim(),
                        genderId: genderId,
                        contactNo: _mobileController.text.trim(),
                        password: _passController.text.trim(),
                        email: _emailController.text.trim(),
                        lastName: _lastNameController.text.trim(),
                        firstName: _firstNameController.text.trim(),
                        code: _codeController.text.trim(),
                      natureId: natureId
                    );
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showProcessSnackbar(
                          message: 'Please select a plan',
                          duration: const Duration(seconds: 2)
                      ),
                    );
                    Get.to(()=>DoctorSubscriptionPlan(registerDoctorModel: registerDoctorModel!));
                  }

                }




              }

            },
            //()=>Get.to(()=>SubscriptionPage(),transition: Transition.fade),
            style: TextButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                fixedSize: Size(380.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                )),
            child: isPostingData? SpinKitDualRing(color: ColorManager.white,size: 16,):
            Text(
              'Register',
              style: getMediumStyle(
                  color: ColorManager.white,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
