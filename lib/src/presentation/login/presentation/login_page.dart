import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/login/presentation/status_page.dart';

import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../core/update_service/update_service.dart';
import '../../../core/update_service/update_service_impl.dart';
import '../../common/snackbar.dart';
import '../../register/presentation/register.dart';
import '../domain/service/login_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageCopyState();
}

class _LoginPageCopyState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {


  final UpdateService _updateService = UpdateServiceImpl();

  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;



  int selectedOption = 0;

  final formKey = GlobalKey<FormState>();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscureText = true ;
  bool _remember = false;
  bool isLoading = false;


  void _onUpdateSuccess() {
    Widget alertDialogOkButton = TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text("Ok")
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Update Successfully Installed"),
      content: const Text("MeroUpachar has been updated successfully! ✔ "),
      actions: [
        alertDialogOkButton
      ],
    );
    showDialog(context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }  );
  }

  void _onUpdateFailure(String error) {
    Widget alertDialogTryAgainButton = TextButton(
        onPressed: () {
          _updateService.checkForInAppUpdate(_onUpdateSuccess, _onUpdateFailure);
          Navigator.pop(context);
        },
        child: const Text("Try Again?")
    );
    Widget alertDialogCancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text("Dismiss"),
    );
    AlertDialog alertDialog = AlertDialog(
      title: const Text("Update Failed To Install ❌"),
      content: Text("MeroUpachar has failed to update because: \n $error"),
      actions: [
        alertDialogTryAgainButton,
        alertDialogCancelButton
      ],
    );
    showDialog(context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }




  @override
  void initState() {
    super.initState();
    _updateService.checkForInAppUpdate(_onUpdateSuccess, _onUpdateFailure);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Define the slide-up animation
    _slideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0), // Start from the bottom
      end: Offset(0.0, 0.0), // End at the top
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.primary,
        body: AutofillGroup(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeIn(
                  duration: Duration(seconds: 2),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1 / 3,
                    padding: EdgeInsets.symmetric(horizontal: 18.w),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Sign into your Account',
                        style: getSemiBoldHeadStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                ),
                h10,
                Expanded(
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorManager.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            h20,
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {

                                        if(selectedOption != 0){
                                          _usernameController.clear();
                                          _codeController.clear();
                                          _emailController.clear();
                                          _passController.clear();
                                        }
                                        selectedOption = 1;

                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:selectedOption == 1 ? ColorManager.primary: ColorManager.white,
                                          child: Image.asset(selectedOption == 1 ? 'assets/images/logins/org_select.png':'assets/images/logins/org_unselect.png'),
                                        ),
                                        h10,
                                        Text('Organization',style: getRegularStyle(color: selectedOption == 1 ? ColorManager.primary:ColorManager.black,fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {

                                        if(selectedOption != 0){
                                          _usernameController.clear();
                                          _codeController.clear();
                                          _emailController.clear();
                                          _passController.clear();
                                        }
                                        selectedOption = 3;

                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: selectedOption == 3 ? ColorManager.primary: ColorManager.white,
                                          child: Image.asset(selectedOption == 3 ? 'assets/images/logins/doctor_select.png':'assets/images/logins/doctor_unselect.png'),
                                        ),
                                        h10,
                                        Text('Professional',style: getRegularStyle(color: selectedOption == 3 ? ColorManager.primary:ColorManager.black,fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {

                                        if(selectedOption != 0){
                                          _usernameController.clear();
                                          _codeController.clear();
                                          _emailController.clear();
                                          _passController.clear();
                                        }
                                        selectedOption = 4;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: selectedOption == 4 ? ColorManager.primary: ColorManager.white,
                                          child: Image.asset(selectedOption == 4 ? 'assets/images/logins/patient_select.png':'assets/images/logins/patient_unselect.png'),
                                        ),
                                        h10,
                                        Text('Patient',style: getRegularStyle(color: selectedOption == 4 ? ColorManager.primary:ColorManager.black,fontSize: 14),),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            h20,


                            if(selectedOption != 4)
                            Container(
                              child:Column(
                                children: [
                                  TextFormField(
                                    // autofillHints: [AutofillHints.givenName] ,
                                    controller: _codeController,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Code is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                                      labelText: 'Code',
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
                                    ),
                                  ),
                                  h10,
                                  TextFormField(
                                    autofillHints: [AutofillHints.email],
                                    controller: _emailController,
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Email is required';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                                      labelText: 'E-mail',
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
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if(selectedOption == 4)
                            TextFormField(
                              autofillHints: [AutofillHints.username],
                              controller: _usernameController,
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                                labelText: 'Username',
                                labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ColorManager.black
                                    )
                                ),
                                focusedBorder : OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: ColorManager.black
                                    )
                                ),
                              ),
                            ),
                            h10,
                            TextFormField(
                              autofillHints: [AutofillHints.password],
                              controller: _passController,
                              obscureText: _obscureText,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },

                              decoration: InputDecoration(
                                  floatingLabelStyle: getRegularStyle(color: ColorManager.primary,fontSize: 14),
                                  labelText: 'Password',
                                  labelStyle: getRegularStyle(color: ColorManager.black,fontSize: 14),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                          color: ColorManager.black
                                      )
                                  ),
                                  focusedBorder : OutlineInputBorder(
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
                            h20,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Checkbox(
                                  visualDensity: VisualDensity.comfortable,
                                  activeColor: ColorManager.primary,
                                    value: _remember,
                                    onChanged: (value){
                                     setState(() {
                                       _remember = !_remember;
                                     });
                                    }
                                ),
                                Text('Remember me',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)
                              ],
                            ),
                            h10,
                            ElevatedButton(
                              onPressed: isLoading? null :
                                  () async {
                                final scaffoldMessage = ScaffoldMessenger.of(context);
                                if (formKey.currentState!.validate()) {

                                  if(selectedOption == 0){
                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                        message: 'Please select a login type',
                                        duration: const Duration(milliseconds: 1400),
                                      ),
                                    );
                                  }
                                  else{
                                    setState(() {
                                      isLoading = true;
                                    });

                                    // login();
                                    final response = await ref.read(userLoginProvider).userLogin(
                                      code: selectedOption == 4 ? 'N/A':_codeController.text.trim(),
                                      accountId: selectedOption,
                                      email: selectedOption==4? _usernameController.text.trim():_emailController.text.trim(),
                                      password: _passController.text.trim(),
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
                                        isLoading = false;
                                      });
                                    }
                                    else {

                                      TextInput.finishAutofillContext(shouldSave: _remember);

                                      await ref.read(userProvider.notifier).getUserInfo(response:response.getOrElse(() => {}));
                                      scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showSuccessSnackbar(
                                              message: 'Login Successful',
                                              duration: const Duration(milliseconds: 1200)
                                          )
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });

                                      Get.offAll(()=>StatusPage(accountId: selectedOption,));
                                    }
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
                              child:isLoading ?
                              SpinKitDualRing(color: ColorManager.white,size: 12,)
                                  :Text(
                                'Sign In',
                                style: getMediumStyle(
                                    color: ColorManager.white,
                                    fontSize: 18),
                              ),
                            ),

                            h20,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an account yet?',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                                TextButton(
                                    onPressed: ()=>Get.to(()=>RegisterPage(),transition: Transition.fadeIn),
                                    child: Text('Register.',style: getRegularStyle(color: ColorManager.primary,fontSize: 16),))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
