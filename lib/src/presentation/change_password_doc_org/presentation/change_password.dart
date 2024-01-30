


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../common/snackbar.dart';
import '../../login/domain/model/user.dart';
import '../domain/service/change_user_pwd_services.dart';

class ChangePwd extends StatefulWidget {
  final User userBox;
  ChangePwd(this.userBox);

  @override
  State<ChangePwd> createState() => _ChangePwdState();
}

class _ChangePwdState extends State<ChangePwd> {

  final formKey = GlobalKey<FormState>();

  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _confirmPwdController = TextEditingController();

  bool _obscureText = true;
  bool _obscureText2 = true;
  bool _obscureText3 = true;

  bool _isPosting = false;

  bool _pwdCheck = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.white.withOpacity(0.99),
        appBar: AppBar(
          elevation: 1,
          backgroundColor: ColorManager.primaryDark,
          automaticallyImplyLeading: false,
          title: Text('Change Password',style: getMediumStyle(color: ColorManager.white,fontSize: 20),),
          centerTitle: true,
          leading: IconButton(
              onPressed:()=>Get.back(),
              icon: FaIcon(Icons.chevron_left,color: ColorManager.white,)) ,


        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 18.w),
          child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  h10,
                  TextFormField(
                    controller: _oldPwdController,
                    obscureText: _obscureText,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Old Password is required';
                      }
                      if(!_pwdCheck){
                        return 'Invalid password';
                      }
                      return null;
                    },
                    onChanged: (value){
                      setState(() {
                        _pwdCheck = true;
                      });
                    },
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                        labelText: 'Old Password',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 14),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
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
                  h10,
                  TextFormField(
                    controller: _newPwdController,
                    obscureText: _obscureText2,
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
                      if(value == _oldPwdController.text.trim()){
                        return 'New password cannot match old password';
                      }
                      return null;
                    },

                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                        labelText: 'New Password',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 14),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
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
                  h10,
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Confirm Password is required';
                      } else if(value != _newPwdController.text.trim()){
                        return 'Password doesn\'t match';
                      }
                      return null;
                    },
                    controller: _confirmPwdController,
                    obscureText: _obscureText3,
                    decoration: InputDecoration(
                        floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                        labelText: 'Confirm Password',
                        labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 14),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: ColorManager.black
                            )
                        ),
                        suffixIcon: IconButton(
                          onPressed: (){
                            setState(() {
                              _obscureText3 = !_obscureText3;
                            });
                          },
                          icon: _obscureText3? FaIcon(CupertinoIcons.eye,color: ColorManager.black,):FaIcon(CupertinoIcons.eye_slash,color: ColorManager.black,),
                        )
                    ),
                  ),
                  h10,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      fixedSize: Size.fromWidth(150)
                    ),
                      onPressed: !_isPosting ? ()async{
                        final scaffoldMessage = ScaffoldMessenger.of(context);

                      if(formKey.currentState!.validate()){
                        // print(widget.userBox.username);
                        setState(() {
                          _isPosting = true;
                        });
                        final response = await ChangePwdUserService().changeUserPwd(
                            userId: widget.userBox.typeID ==4 ? widget.userBox.username! : widget.userBox.userID!,
                            oldPwd: _oldPwdController.text.trim(),
                            newPwd: _newPwdController.text.trim()
                        );
                        if(response.isLeft()){
                          final leftVal = response.fold((l) => l, (r) => null);
                          if(leftVal == 'Old Password is incorrect'){
                            setState(() {
                              _pwdCheck = false;
                            });
                          }
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showFailureSnackbar(
                              message: leftVal!,
                              duration: const Duration(milliseconds: 1400),
                            ),
                          );
                          setState(() {
                            _isPosting = false;
                          });
                        }
                        else{
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showSuccessSnackbar(
                              message: 'Change Password confirmed!',
                              duration: const Duration(milliseconds: 1400),
                            ),
                          );
                          setState(() {
                            _isPosting = false;
                          });
                          Navigator.pop(context);
                        }
                      }
                      } : null,
                      child: _isPosting
                          ? SpinKitDualRing(color: ColorManager.white,size: 16,) 
                          
                          :Text('Save',style: getMediumStyle(color: ColorManager.white,fontSize: 16),)
                  )
                ],
              )
          ),
        ),

      ),
    );
  }
}
