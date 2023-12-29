



import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../core/api.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';
import '../../subscription-plan/presentation/subscription_plan_org.dart';

class RegisterOrganization extends ConsumerStatefulWidget {
  final int accountId;
  RegisterOrganization({required this.accountId});

  @override
  ConsumerState<RegisterOrganization> createState() => _RegisterOrganizationState();
}

class _RegisterOrganizationState extends ConsumerState<RegisterOrganization> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _panController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();

  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  List<String> natureType = ['Select Nature Type','Service Provider', 'Payeer', 'Third Party'];
  int natureId = 0;
  String selectedNatureType = 'Select Nature Type';
  bool _obscureText = true ;
  bool _obscureText2 = true ;
  bool _isChecked = false;

  bool isPostingData = false;

  final dio =Dio();

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

  Future<Either<String, dynamic>> orgRegister({

    required String orgName,
    required String code,
    required int pan,
    required String email,
    required String mobileNo,
    required int natureId,
    required String password
  }) async {
    try {
      final response = await dio.post(
          Api.registerOrganization,
          data: {
            "organizationName": orgName,
            "pan": pan,
            "email": email,
            "contact": mobileNo,
            "natureId":natureId,
            "password":password,
            "code":code
          }
      );

      (response.data);
      setState(() {
        outputValue = response.data;
      });
      return Right(response.data);
    } on DioException catch (err) {
      (err.response);


      throw Exception('${err.response!.data['message']}');
    }}



  @override
  Widget build(BuildContext context) {
    return _buildMerchant();
  }

  Widget _buildMerchant() {
    // final authNotifier = ref.watch(organizationRegister.notifier);
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: 18.h,
          ),
          DropdownButtonFormField<String>(
            validator: (value){
              if(selectedNatureType == natureType[0]){
                return 'Please select a nature type';
              }
              return null;
            },
            value: selectedNatureType,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorManager.black.withOpacity(0.5)
                          )
                      ),
              labelText: 'Select Nature Type',
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
            items: natureType
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
                selectedNatureType = value!;
                natureId = natureType.indexOf(value);
              });
            },
          ),
          SizedBox(
            height: 18.h,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _panController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    if (value.length !=9) {
                      return 'Enter a valid PAN number';
                    }
                    if (value.contains(' ')) {
                      return 'Do not enter spaces';
                    }
                    if (!value.contains(RegExp(r'^\d+$'))) {
                      return 'PAN can only be in digits';
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
                      labelText: 'PAN',
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
                  controller: _codeController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'Required';
                    }
                    if (value.length < 2 && value.length > 6) {
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
          TextFormField(
            controller: _firstNameController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if (value!.isEmpty) {
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
                labelText: 'Name',
                labelStyle: getRegularStyle(color: ColorManager.black),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                        color: ColorManager.black
                    )
                )
            ),
          ),
          SizedBox(
            height: 18.h,
          ),
          TextFormField(
            controller: _emailController,
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
            keyboardType: TextInputType.emailAddress,
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
          SizedBox(
            height: 18.h,
          ),
          TextFormField(
            controller: _mobileController,
            keyboardType: TextInputType.number,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value){
              if (value!.isEmpty) {
                return 'Contact number is required';
              }
              if (value.length != 10) {
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
              labelText: 'Contact Number',
              labelStyle: getRegularStyle(color: ColorManager.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                      color: ColorManager.black
                  )
              ),
            ),
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
            height: 50.h,
          ),
          ElevatedButton(
            onPressed: isPostingData
                ? null // Disable the button while posting data
                :() async {
              final scaffoldMessage = ScaffoldMessenger.of(context);
              if (formKey.currentState!.validate()) {
                if (widget.accountId == 1) {
                  setState(() {
                    isPostingData = true; // Show loading spinner
                  });
                  ('organization');
                  ('natureId');
                  await orgRegister(
                  orgName: _firstNameController.text.trim(),
                  pan: int.parse(_panController.text.trim()),
                  email: _emailController.text.trim(),
                  mobileNo: _mobileController.text.trim(),
                  natureId: natureId,
                  password: _passController.text.trim(),
                  code: _codeController.text.trim()
                  ).then((value) {
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showProcessSnackbar(
                          message: 'Please select a plan',
                          duration: const Duration(seconds: 2)
                      ),
                    );

                  }).then((value) {
                    if(outputValue != {}){
                      setState(() {
                        isPostingData = false;
                        formKey.currentState?.reset();
                      });
                      Get.to(()=>OrgSubscriptionPlan(outputValue: outputValue,password: _passController.text.trim(),));

                    }
                  }).catchError((e){
                    ('$e');
                    scaffoldMessage.showSnackBar(
                      SnackbarUtil.showFailureSnackbar(
                          message: '$e',
                          duration: const Duration(seconds: 2)
                      ),
                    );
                    setState(() {
                      isPostingData = false;
                    });
                  });



                }
              }


            },
            style: TextButton.styleFrom(
                backgroundColor: ColorManager.primary,
                foregroundColor: Colors.white,
                fixedSize: Size(380.w, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                )),
            child:  isPostingData
                ? SpinKitDualRing(color: ColorManager.white,size: 24,)
                :Text(
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
