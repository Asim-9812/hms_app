


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/presentation/login/presentation/login_page.dart';
import 'package:meroupachar/src/presentation/register/domain/register_service.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';

class RegisterPatient extends ConsumerStatefulWidget {
  final int accountId;
  RegisterPatient({required this.accountId});

  @override
  ConsumerState<RegisterPatient> createState() => _RegisterPatientState();
}

class _RegisterPatientState extends ConsumerState<RegisterPatient> {

  List<String> genderType = ['Select Gender','Male', 'Female', 'Other'];
  String selectedGender = 'Select Gender';
  int genderId = 0;
  final formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passConfirmController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _obscureText = true ;
  bool isPostingData = false;



  @override
  Widget build(BuildContext context) {
    return _buildPatient();
  }

  Widget _buildPatient() {
    return Form(
      key: formKey,
      child: Column(
        children: [

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
          SizedBox(
            height: 18.h,
          ),

          DropdownButtonFormField<String>(
            value: selectedGender,
            validator: (value){
              if(selectedGender == genderType[0]){
                return 'Please select a Gender';
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
              SizedBox(
                width: 18.w,
              ),
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

                    if (!value.contains(RegExp(r'^\d+$'))) {
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
            obscureText: _obscureText,
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
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: _obscureText? FaIcon(CupertinoIcons.eye,color: ColorManager.black,):FaIcon(CupertinoIcons.eye_slash,color: ColorManager.black,),
                )
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          ElevatedButton(
            onPressed:isPostingData == true ? null :() async {
              final scaffoldMessage = ScaffoldMessenger.of(context);
              if(formKey.currentState!.validate()){
                setState(() {
                  isPostingData = true;
                });
                final response = await RegisterService().patientRegister(
                    firstName: _firstNameController.text.trim(),
                    lastName: _lastNameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passController.text.trim(),
                    mobileNo: _mobileController.text.trim(),
                    // userName: _usernameController.text.trim(),
                    genderId: genderId
                );
                if(response.isLeft()){
                  final leftValue = response.fold((l) => l, (r) => null);
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showFailureSnackbar(
                        message: '$leftValue',
                        duration: const Duration(seconds: 2)
                    ),
                  );
                  setState(() {
                    isPostingData = false;
                  });
                } else{
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showSuccessSnackbar(
                        message: 'Registered Successfully.',
                        duration: const Duration(seconds: 2)
                    ),
                  );
                  scaffoldMessage.showSnackBar(
                    SnackbarUtil.showSuccessSnackbar(
                        message: 'Please check your email for credentials.',
                        duration: const Duration(seconds: 2)
                    ),
                  );
                  setState(() {
                    isPostingData = false;
                  });
              }

                Get.offAll(()=>LoginPage());
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
            child: isPostingData == true? SpinKitDualRing(color: ColorManager.white,size: 16,):Text(
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
