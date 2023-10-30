import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/core/resources/value_manager.dart';
import 'package:animate_do/animate_do.dart';
import 'package:medical_app/src/presentation/login/presentation/status_page.dart';
import 'package:medical_app/src/presentation/register/presentation/register.dart';

import '../../common/snackbar.dart';
import '../domain/service/login_service.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // List<String> accountType = ['Merchant','Organization','Professional', 'Patient'];
  // String selectedValue = 'Professional';
  bool _obscureText = true ;
  int selectedOption = 1;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool _isChecked = false;
  bool isLoading = false;

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

  late Box box1;

  @override
  void initState() {
    super.initState();
    createOpenBox();
  }

  /// create a box with this function below
  void createOpenBox() async {
    box1 = await Hive.openBox('logindata');
    getData();
  }


  /// gets the stored data from the box and assigns it to the controllers
  void getData() async {
    if (box1.get('email') != null) {
      _emailController.text = box1.get('email');
      _isChecked = true;
      setState(() {});
    }
    if (box1.get('password') != null) {
      _passController.text = box1.get('password');
      _isChecked = true;
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {

    // Get the screen size
    final screenSize = MediaQuery.of(context).size;
    (screenSize);

    // Check if width is greater than height
    bool isWideScreen = screenSize.width > 500;
    bool isNarrowScreen = screenSize.width < 380;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: ColorManager.primaryDark,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildBody(isWideScreen),
              _buildBody2(isWideScreen,isNarrowScreen)

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(bool isWideScreen) {
    return Container(
      height: MediaQuery.of(context).size.height * 1.5 / 5,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: -120.h,
            left: -60.h,
            child: ZoomIn(
              duration: const Duration(milliseconds: 700),
              child: CircleAvatar(
                backgroundColor: ColorManager.primaryOpacity80,
                radius: 150.sp,
              ),
            ),
          ),
          Positioned(
            top: -120.h,
            left: -70.h,
            child: ZoomIn(
              duration: const Duration(milliseconds: 500),
              child: CircleAvatar(
                backgroundColor: ColorManager.primary.withOpacity(0.5),
                radius: 220.sp,
              ),
            ),
          ),
          FadeIn(
            duration: const Duration(milliseconds: 700),
            delay: const Duration(milliseconds: 300),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 32.w, bottom: 50.h),
                child: Text(
                  'Sign into your Account',
                  style: getSemiBoldHeadStyle(color: Colors.white,fontSize:isWideScreen==true?30: 30.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody2(bool isWideScreen,bool isNarrowScreen) {
    final fontSize = isWideScreen ? 18.0 : 18.sp;
    final fontSize2 = isWideScreen ? 14.0 : 14.sp;
    final iconSize = isWideScreen ? 20.0 : 20.sp;

    return SlideInUp(
      duration: const Duration(milliseconds: 700),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        height: MediaQuery.of(context).size.height * 3.5 / 5,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: FadeIn(
          duration:const Duration(milliseconds: 800),
          delay:const Duration(milliseconds: 500),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  h10,
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      Container(
                        height: 100,
                        width: 90.w,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOption = 1;
                              _emailController.clear();
                              _usernameController.clear();
                              _passController.clear();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: selectedOption == 1 ? ColorManager.primaryDark : ColorManager.dotGrey),
                                  shape: BoxShape.circle,
                                  color: selectedOption == 1 ? ColorManager.primary : Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/org_login.png',
                                    width: selectedOption == 1 ?50:30,
                                    height: selectedOption == 1 ?50:30,
                                  ),
                                ),
                              ),
                              h10,
                              Text(
                                'Organization',
                                style: getRegularStyle(color: selectedOption == 1 ? ColorManager.black : ColorManager.textGrey, fontSize: fontSize2),
                              )
                            ],
                          ),
                        ),
                      ),
                      w05,
                      Container(
                        height: 100,
                        width: 90.w,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOption = 3;
                              _emailController.clear();
                              _usernameController.clear();
                              _passController.clear();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: selectedOption == 3 ? ColorManager.primaryDark : ColorManager.dotGrey),
                                  shape: BoxShape.circle,
                                  color: selectedOption ==3 ? ColorManager.primary : Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/doctor_login.png',
                                    width: selectedOption == 3 ?50:30,
                                    height: selectedOption == 3 ?50:30,
                                  ),
                                ),
                              ),
                              h10,
                              Text(
                                'Doctor',
                                style: getRegularStyle(color: selectedOption == 3 ? ColorManager.black : ColorManager.textGrey, fontSize: fontSize2),
                              )
                            ],
                          ),
                        ),
                      ),
                      w05,
                      Container(
                        height: 100,
                        width: 90.w,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOption = 4;
                              _emailController.clear();
                              _usernameController.clear();
                              _passController.clear();
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: selectedOption == 4 ? ColorManager.primaryDark : ColorManager.dotGrey),
                                  shape: BoxShape.circle,
                                  color: selectedOption == 4 ? ColorManager.primary : Colors.transparent,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/icons/patient_login.png',
                                    width: selectedOption == 4 ?50:30,
                                    height: selectedOption == 4 ?50:30,
                                  ),
                                ),
                              ),
                              h10,
                              Text(
                                'Patient',
                                style: getRegularStyle(color: selectedOption == 4 ? ColorManager.black : ColorManager.textGrey, fontSize: fontSize2),
                              )
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  h20,
                  selectedOption!=4
                  ?TextFormField(
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
                        )
                    ),
                  )
                      : TextFormField(
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
                        )
                    ),
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  TextFormField(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: (value) {
                                _isChecked = !_isChecked;
                                setState(() {});
                              },
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.resolveWith(
                                      (states) => getColor(states)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                          Text(
                            'Remember me',
                            style: getRegularStyle(
                                color: ColorManager.textGrey,
                                fontSize: 14),
                          )
                        ],
                      ),
                      GestureDetector(
                        onTap: () { },
                        child: Text(
                          'Forgot Password?',
                          style: getMediumStyle(
                              color: ColorManager.blue, fontSize: 14),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 18.h,
                  ),
                  ElevatedButton(
                    onPressed: isLoading? null :
                        () async {
                          final scaffoldMessage = ScaffoldMessenger.of(context);
                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            login();
                            final response = await ref.read(userLoginProvider).userLogin(
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
                        SpinKitDualRing(color: ColorManager.white,size: iconSize,)
                        :Text(
                      'Sign In',
                      style: getMediumStyle(
                          color: ColorManager.white,
                          fontSize: 18),
                    ),
                  ),

                  SizedBox(height: 50.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account yet?',style: getRegularStyle(color: ColorManager.black,fontSize: fontSize),),
                      TextButton(
                          onPressed: ()=>Get.to(()=>RegisterPage(),transition: Transition.fadeIn),
                          child: Text('Register.',style: getRegularStyle(color: ColorManager.blue,fontSize: fontSize),))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// adds the user info into (box) the local database (Hive)
  void login() {
    if (_isChecked) {
      box1.put('email', _emailController.value.text);
      box1.put('password', _passController.value.text);
    }
  }

  /// clears the box or removes the stored credentials.
  void removeLoginInfo(){
    if(!_isChecked){
      box1.clear();
    }
  }


}
