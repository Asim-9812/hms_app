

import 'package:animate_do/animate_do.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
// import 'package:esewa_flutter_sdk/esewa_config.dart';
// import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
// import 'package:esewa_flutter_sdk/esewa_payment.dart';
// import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/core/utils/shimmer.dart';
import 'package:medical_app/src/presentation/login/presentation/login_page.dart';
import 'package:medical_app/src/presentation/subscription-plan/domain/scheme_service.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/api.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/services/payment_services.dart';
import '../../common/snackbar.dart';
import '../../register/domain/register_model/register_model.dart';
import '../../register/domain/register_service.dart';
import '../domain/scheme_model.dart';

class SubscriptionPageDoctor extends ConsumerStatefulWidget {
  final RegisterDoctorModel registerDoctorModel;
  SubscriptionPageDoctor({required this.registerDoctorModel});

  @override
  ConsumerState<SubscriptionPageDoctor> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends ConsumerState<SubscriptionPageDoctor> {





  int selectedDuration = 0;
  int selectSubscription = 0;
  int schemePlanId = 1;
  String schemePlanName = 'GOLD';
  final dio = Dio();
  SchemePlaneModel? selectedScheme;
  bool isPostingData = false;
  int amount = 1000;

  int paymentOption = 0;
  int selectedPayment = 0;

  void onSelected(int selectedPaymentOption){
    setState(() {
      paymentOption = selectedPaymentOption;
    });
  }

  Color? getPaymentContainerColor(int paymentOption) {
    return selectedPayment == paymentOption ? ColorManager.primary : null;
  }

  Map<String,dynamic> outputValue = {};

  Future<dartz.Either<String, dynamic>> docRegister() async {
    try {
      final response = await dio.post(
          Api.registerDoctor,
          data: {
            "doctorID": 0,
            "docID": "",
            "firstName": widget.registerDoctorModel.firstName,
            "lastName": widget.registerDoctorModel.lastName,
            "doctorEmail": widget.registerDoctorModel.email,
            "doctorPassword": widget.registerDoctorModel.password,
            "roleID": 1,
            "referenceNo": "1",
            "subscriptionID": 0,
            "isActive": true,
            "entryDate": "2023-07-17T10:43:10.315Z",
            "genderID": 1,
            "key": "12",
            "flag": "Insert",
            "code":widget.registerDoctorModel.code
          }
      );

      setState(() {
        outputValue = response.data;
      });



      return dartz.Right(response.data);
    } on DioException catch (err) {
      (err.response);
      throw Exception('1. ${err.response!.data['message']}');
    }}

  Future<dartz.Either<String, dynamic>> subscriptionPlanDoctor({

    required int schemePlanId,
  }) async {
    try {
      final response = await dio.post(
          Api.subscriptionPlan,
          data: {
            "id": 0,
            "userid": '${outputValue['result']['docID']}',
            "subscriptionID": schemePlanId,
            "fromDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "toDate": selectSubscription == 7 || selectSubscription == 8
                ? "${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 15))).toString()}"
                :selectedDuration==0
                ?"${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30))).toString()}"
                :"${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 365))).toString()}",
            "flag": ""
          }
      );

      (response.data);
      return dartz.Right(response.data);
    } on DioException catch (err) {
      (err.response);


      throw Exception('2. ${err.response!.data['message']}');
    }}



  Future<dartz.Either<String, dynamic>> userRegisterDoctor() async {
    try {
      final response = await dio.post(
          Api.userRegister,
          data: {
            "userID": '${outputValue['result']['docID']}',
            "typeID": 3,
            "parentID": "0",
            "firstName": '${outputValue['result']['firstName']}',
            "lastName": '${outputValue['result']['lastName']}',
            "password": widget.registerDoctorModel.password,
            "contactNo": widget.registerDoctorModel.contactNo,
            "panNo": 0,
            "natureID": 0,
            "liscenceNo": 0,
            "email": widget.registerDoctorModel.email,
            "roleID": 2,
            "joinedDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "isActive": true,
            "genderID": 0,
            "entryDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "key": "12",
            "flag": "Register",
            "code":widget.registerDoctorModel.code
          }
      );

      (response.data);
      return dartz.Right(response.data);
    } on DioException catch (err) {
      (err.response);


      throw Exception('3. ${err.response!.data['message']}');
    }}





  @override
  Widget build(BuildContext context) {
    (widget.registerDoctorModel);
    final schemeData = ref.watch(schemeList);
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(
        children: [
          Visibility(
              visible: selectedDuration == 0,
              child: _buildMonthBody(schemeData)
          ),
          Visibility(
              visible: selectedDuration == 1,
              child: _buildYearBody(schemeData)
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: 50.h,
                    width: 250.w,
                    decoration:BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                            color: ColorManager.black.withOpacity(0.5),
                            width: 0.5
                        )
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedDuration = 0;
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            width: 90.w,
                            child: Center(child: Text('Monthly',style: selectedDuration==0? getRegularStyle(color: ColorManager.black,fontSize: 20):getRegularStyle(color: ColorManager.black.withOpacity(0.5)),)),
                          ),
                        ),
                        VerticalDivider(
                          endIndent: 8.h,
                          indent: 8.h,
                          thickness: 0.5,
                          color: ColorManager.black,
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              selectedDuration = 1;
                            });
                          },
                          splashColor: Colors.transparent,
                          child: Container(
                            width: 90.w,
                            child: Center(child: Text('Yearly',style: selectedDuration==1? getRegularStyle(color: ColorManager.black,fontSize: 20):getRegularStyle(color: ColorManager.black.withOpacity(0.5)),)),
                          ),
                        ),
                      ],
                    )
                ),
                h20,
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: ColorManager.primary
                    ),
                    onPressed: isPostingData
                        ? null // Disable the button while posting data
                        : ()async{
                      final scaffoldMessage = ScaffoldMessenger.of(context);
                      (schemePlanName.toLowerCase());
                      if(selectedScheme == null){
                        scaffoldMessage.showSnackBar(
                          SnackbarUtil.showFailureSnackbar(
                              message: 'Please Select a scheme first',
                              duration: const Duration(seconds: 2)
                          ),
                        );
                      }
                      else if(schemePlanName.toLowerCase() =='trail 15 days'||schemePlanName.toLowerCase() =='trial 15 days' ){
                        setState(() {
                          isPostingData = true; // Show loading spinner
                        });
                        subscriptionPlanDoctor(
                            schemePlanId: selectedScheme?.schemeplanID ?? 0
                        ).then((value) async => await userRegisterDoctor()).then((value) {
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showSuccessSnackbar(
                                message: 'User registered successfully',
                                duration: const Duration(seconds: 2)
                            ),
                          );
                          setState(() {
                            isPostingData = false;
                          });
                          Get.offAll(()=>LoginPage());
                        }).catchError((e){
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showFailureSnackbar(
                                message: '$e',
                                duration: const Duration(seconds: 2)
                            ),
                          );

                        });
                      }
                      else{

                        await docRegister().then((value) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {


                              return StatefulBuilder(
                                  builder: (context,setState) {
                                    return Container(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // InkWell(
                                              //   onTap:(){
                                              //     setState(() {
                                              //       selectedPayment = 1;
                                              //     });
                                              //   },
                                              //   child: Container(
                                              //     decoration: BoxDecoration(
                                              //         borderRadius: BorderRadius.circular(10),
                                              //         color: getPaymentContainerColor(1),
                                              //         border: Border.all(
                                              //             color: ColorManager.black.withOpacity(0.5)
                                              //         )
                                              //     ),
                                              //     padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                                              //     child: Column(
                                              //       mainAxisSize: MainAxisSize.min,
                                              //       mainAxisAlignment: MainAxisAlignment.center,
                                              //       crossAxisAlignment: CrossAxisAlignment.center,
                                              //       children: [
                                              //         Image.asset('assets/images/esewa.png',height: 30,fit: BoxFit.contain,),
                                              //         h10,
                                              //         Text('E-sewa',style: getRegularStyle(color: ColorManager.black),),
                                              //       ],
                                              //     ),
                                              //   ),
                                              // ),
                                              InkWell(
                                                onTap:(){
                                                  setState(() {
                                                    selectedPayment = 2;
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: getPaymentContainerColor(2),
                                                      border: Border.all(
                                                          color: ColorManager.black.withOpacity(0.5)
                                                      )
                                                  ),
                                                  padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Image.asset('assets/images/khalti.png',height: 30,fit: BoxFit.contain,),
                                                      h10,
                                                      Text('Khalti',style: getRegularStyle(color: ColorManager.black),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: ColorManager.primary,
                                                fixedSize: Size.fromWidth(300)

                                            ),
                                            onPressed: isPostingData
                                                ? null // Disable the button while posting data
                                                : () {
                                              setState(() {
                                                isPostingData = true; // Show loading spinner
                                              });

                                              if(selectedPayment == 1){
                                                Navigator.pop(context);
                                                // payWithEsewaInApp(productId: outputValue['result']['docID'], amount: amount, schemePlanId: schemePlanId, schemePlanName: schemePlanName);
                                              }else if(selectedPayment ==2 ){
                                                Navigator.pop(context);
                                                payWithKhaltiInApp(productId: outputValue['result']['docID'], amount: amount, schemePlanId: schemePlanId, schemePlanName: schemePlanName);
                                                (selectedPayment);

                                              } else {
                                                final scaffoldMessage = ScaffoldMessenger.of(context);
                                                scaffoldMessage.showSnackBar(
                                                  SnackbarUtil.showFailureSnackbar(
                                                    message: 'Please select a payment option',
                                                    duration: const Duration(milliseconds: 1400),
                                                  ),
                                                );
                                              }

                                            },
                                            child:isPostingData
                                                ?SpinKitDualRing(color: ColorManager.white,size: 20,)
                                                : Text('Select',style: getRegularStyle(color: ColorManager.white),),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              );
                            },
                          );
                        });

                            // payWithKhaltiInApp(productId: outputValue['result']['docID'], amount: amount, schemePlanId: schemePlanId, schemePlanName: schemePlanName)


                      }

                    },
                    child: isPostingData
                        ?SpinKitDualRing(color: ColorManager.white,size: 20,)
                        :Text('Select',style: getMediumStyle(color: ColorManager.white,fontSize: 24),)
                ),
                h20,
              ],
            ),
          )
        ],

      ),
    );
  }

  ///-------------------------ESEWA SERVICES---------------------------///

  // payWithEsewaInApp({
  //   required String productId,
  //   required int amount,
  //   required int schemePlanId,
  //   required String schemePlanName
  // }){
  //   const String kEsewaClientId = 'JB0BBQ4aD0UqIThFJwAKBgAXEUkEGQUBBAwdOgABHD4DChwUAB0R';
  //   const String kEsewaSecretKey = 'BhwIWQQADhIYSxILExMcAgFXFhcOBwAKBgAXEQ==';
  //   try{
  //     EsewaFlutterSdk.initPayment(
  //         esewaConfig: EsewaConfig(
  //           environment: Environment.test,
  //           clientId: kEsewaClientId,
  //           secretId: kEsewaSecretKey,
  //         ),
  //         esewaPayment: EsewaPayment(
  //           productId: productId,
  //           productName: schemePlanName,
  //           productPrice: '$amount',
  //           callbackUrl: '',
  //         ),
  //         onPaymentSuccess: onEsewaSuccess,
  //         onPaymentFailure: (failure){
  //           setState(() {
  //             isPostingData = false;
  //           });
  //
  //           final scaffoldMessage = ScaffoldMessenger.of(context);
  //
  //           scaffoldMessage.showSnackBar(
  //             SnackbarUtil.showFailureSnackbar(
  //               message: '${failure.toString()}',
  //               duration: const Duration(milliseconds: 1200),
  //             ),
  //           );
  //         },
  //         onPaymentCancellation: (){
  //           setState(() {
  //             isPostingData = false;
  //           });
  //           final scaffoldMessage = ScaffoldMessenger.of(context);
  //           scaffoldMessage.showSnackBar(
  //               SnackbarUtil.showFailureSnackbar(
  //                   message: 'Payment Cancelled',
  //                   duration: const Duration(milliseconds: 1200)
  //               )
  //           );
  //         }
  //     );
  //   }catch(e){
  //
  //
  //   }
  //
  //
  // }
  // void onEsewaSuccess(EsewaPaymentSuccessResult success) async {
  //   final scaffoldMessage = ScaffoldMessenger.of(context);
  //   scaffoldMessage.showSnackBar(
  //     SnackbarUtil.showProcessSnackbar2(
  //         message: 'Please Wait. Verification in process...',
  //         duration: const Duration(seconds: 2)
  //     ),
  //   );
  //   setState(() {
  //     isPostingData = true;
  //   });
  //   if(success.status.toLowerCase() == 'complete'){
  //     final paymentResponse = await ref.read(paymentSuccessProvider).InsertPaymentInfo(
  //         token: '',
  //         amount: double.parse(success.totalAmount).round(),
  //         mobile: widget.registerDoctorModel.contactNo,
  //         pid: success.productId,
  //         orderName: schemePlanName,
  //         tId: success.refId
  //     );
  //     if(paymentResponse.isLeft()){
  //       final leftValue= paymentResponse.fold(
  //               (l) => 'Payment incomplete',
  //               (r) => null
  //       );
  //       scaffoldMessage.showSnackBar(
  //         SnackbarUtil.showFailureSnackbar(
  //             message: '$leftValue',
  //             duration: const Duration(seconds: 2)
  //         ),
  //       );
  //     }else{
  //       subscriptionPlanDoctor(
  //           schemePlanId: selectedScheme?.schemeplanID ?? 0
  //       ).then((value) async => await userRegisterDoctor()).then((value) {
  //         scaffoldMessage.showSnackBar(
  //           SnackbarUtil.showSuccessSnackbar(
  //               message: 'User registered successfully',
  //               duration: const Duration(seconds: 2)
  //           ),
  //         );
  //         setState(() {
  //           isPostingData = false;
  //         });
  //         Get.offAll(()=>LoginPage());
  //       }).catchError((e){
  //         scaffoldMessage.showSnackBar(
  //           SnackbarUtil.showFailureSnackbar(
  //               message: '$e',
  //               duration: const Duration(seconds: 2)
  //           ),
  //         );
  //
  //       });
  //     }
  //   }
  //
  //
  //
  //
  //
  //
  // }





  ///-------------------------ESEWA SERVICES - END---------------------------///


  ///------------------------KHALTI SERVICES---------------------------///
  payWithKhaltiInApp({
    required String productId,
    required int amount,
    required int schemePlanId,
    required String schemePlanName
  }){


    final config = PaymentConfig(
      amount: amount, // Amount should be in paisa
      productIdentity: productId,
      productName: schemePlanName,
    );

    KhaltiScope.of(context).pay(
        config: config,
        preferences: [
          PaymentPreference.khalti
        ],
        onSuccess: onSuccess,
        onFailure: onFailure,
        onCancel: onCancel
    );
  }
  void onSuccess(PaymentSuccessModel success) async {
    final scaffoldMessage = ScaffoldMessenger.of(context);
    scaffoldMessage.showSnackBar(
      SnackbarUtil.showProcessSnackbar2(
          message: 'Please Wait. Verification in process...',
          duration: const Duration(seconds: 2)
      ),
    );
    setState(() {
      isPostingData = true;
    });
    final response = await ref.read(verificationProvider).VerificationProcess(token: success.token, amount: success.amount);
    if(response.isLeft()){
      final leftValue= response.fold(
              (l) => 'Payment incomplete',
              (r) => null
      );
      scaffoldMessage.showSnackBar(
        SnackbarUtil.showFailureSnackbar(
            message: '$leftValue',
            duration: const Duration(seconds: 2)
        ),
      );
    } else{
      final rightValue = response.fold(
              (l) => '',
              (r) => r
      );
      final paymentResponse = await ref.read(paymentSuccessProvider).InsertPaymentInfo(
          token: success.token,
          amount: success.amount,
          mobile: success.mobile,
          pid: success.productIdentity,
          orderName: success.productName,
          tId: success.idx
      );
      if(paymentResponse.isLeft()){
        final leftValue= paymentResponse.fold(
                (l) => 'Payment incomplete',
                (r) => null
        );
        scaffoldMessage.showSnackBar(
          SnackbarUtil.showFailureSnackbar(
              message: '$leftValue',
              duration: const Duration(seconds: 2)
          ),
        );
        setState(() {
          isPostingData = false;
        });
      }else{
        subscriptionPlanDoctor(
            schemePlanId: selectedScheme?.schemeplanID ?? 0
        ).then((value) async => await userRegisterDoctor()).then((value) {
          scaffoldMessage.showSnackBar(
            SnackbarUtil.showSuccessSnackbar(
                message: 'User registered successfully',
                duration: const Duration(seconds: 2)
            ),
          );
          setState(() {
            isPostingData = false;
          });
          Get.offAll(()=>LoginPage());
        }).catchError((e){
          scaffoldMessage.showSnackBar(
            SnackbarUtil.showFailureSnackbar(
                message: '$e',
                duration: const Duration(seconds: 2)
            ),
          );

        });
      }


    }


  }



  void onFailure(PaymentFailureModel failure) {
    setState(() {
      isPostingData = false;
    });

    final scaffoldMessage = ScaffoldMessenger.of(context);

    scaffoldMessage.showSnackBar(
      SnackbarUtil.showFailureSnackbar(
        message: '${failure.toString()}',
        duration: const Duration(milliseconds: 1200),
      ),
    );
  }
  void onCancel(){
    setState(() {
      isPostingData = false;
    });
    final scaffoldMessage = ScaffoldMessenger.of(context);
    scaffoldMessage.showSnackBar(
        SnackbarUtil.showFailureSnackbar(
            message: 'Payment Cancelled',
            duration: const Duration(milliseconds: 1200)
        )
    );
  }

  ///------------------------KHALTI SERVICES - END---------------------------///


  Widget _buildMonthBody(AsyncValue<List<SchemePlaneModel>> schemeData) {


    return schemeData.when(
        data: (data){

          final schemeMonth = data.where(
                  (item) => item.storageType==1).toList();
          // If selectedScheme is null, set a default selected value (the first item in the list)
          selectedScheme ??= schemeMonth.isNotEmpty ? schemeMonth.first : null;

          return FadeIn(
            duration: Duration(milliseconds: 500),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 24.h),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select your',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 24),),
                      h10,
                      Text('Subscription\nPlan',style: getBoldStyle(color: ColorManager.textGrey,fontSize: 50),textAlign: TextAlign.start,),
                      h10,
                      Center(
                        child: _buildSubBanner(
                          schemeName: '${selectedScheme?.schemeName}',
                          schemeDuration: selectedScheme?.storageType == 1 ? 'month' : 'year',
                          schemePrice: int.parse(selectedScheme?.price!.round().toString() ?? '0'),
                          selectSubscription: schemePlanId,
                          gradient: selectedScheme?.schemeName == 'GOLD'
                              ?ColorManager.goldContainer
                              :selectedScheme?.schemeName == 'SILVER'
                              ?ColorManager.silverContainer
                              :selectedScheme?.schemeName == 'PLATINUM'
                              ?ColorManager.blackContainer
                              :ColorManager.primary ,
                        ),
                      ),


                      h20,
                      Container(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: schemeMonth.length,
                          itemBuilder: (context, index) {
                            return _buildSubscriptionTile(
                              onTap: () {
                                setState(() {
                                  schemePlanId = schemeMonth[index].schemeplanID!;
                                  selectedScheme = schemeMonth[index]; // Set the selectedScheme
                                  schemePlanName = schemeMonth[index].schemeName!;
                                  amount =schemeMonth[index].price!.round();
                                });
                                (schemePlanId);
                              },
                              schemeName: '${schemeMonth[index].schemeName}',
                              schemePrice: int.parse(schemeMonth[index].price!.round().toString()),
                              schemeDuration: schemeMonth[index].storageType!,
                              selection: schemeMonth[index].schemeplanID!,
                            );
                          },
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error,stack)=>Center(child: Text('error',style: getRegularStyle(color: ColorManager.black),),),
        loading: ()=>buildShimmerEffect()
    );


  }


  Widget _buildYearBody(AsyncValue<List<SchemePlaneModel>> schemeData) {


    return schemeData.when(
        data: (data){

          final schemeYear = data.where((item) => item.storageType == 2).toList();

          // If selectedScheme is null, set a default selected value (the first item in the list)
          selectedScheme ??= schemeYear.isNotEmpty ? schemeYear.first : null;


          return FadeIn(
            duration: Duration(milliseconds: 500),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 24.h),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select your',style: getRegularStyle(color: ColorManager.textGrey,fontSize: 24),),
                      h10,
                      Text('Subscription\nPlan',style: getBoldStyle(color: ColorManager.textGrey,fontSize: 50),textAlign: TextAlign.start,),
                      h10,
                      Center(
                        child: _buildSubBanner(
                          schemeName: '${selectedScheme?.schemeName}',
                          schemeDuration: selectedScheme?.storageType == 1 ? 'month' : 'year',
                          schemePrice: int.parse(selectedScheme?.price!.round().toString() ?? '0'),
                          selectSubscription: schemePlanId,
                          gradient: selectedScheme?.schemeName == 'GOLD'
                              ?ColorManager.goldContainer
                              :selectedScheme?.schemeName == 'SILVER'
                              ?ColorManager.silverContainer
                              :selectedScheme?.schemeName == 'PLATINUM'
                              ?ColorManager.blackContainer
                              :ColorManager.primary ,
                        ),
                      ),


                      h20,
                      Container(
                        height: 300,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: schemeYear.length,
                          itemBuilder: (context, index) {
                            return _buildSubscriptionTile(
                              onTap: () {
                                setState(() {
                                  schemePlanId = schemeYear[index].schemeplanID!;
                                  selectedScheme = schemeYear[index]; // Set the selectedScheme
                                  schemePlanName = schemeYear[index].schemeName!;
                                  amount =schemeYear[index].price!.round();
                                });
                                (schemePlanId);
                              },
                              schemeName: '${schemeYear[index].schemeName}',
                              schemePrice: int.parse(schemeYear[index].price!.round().toString()),
                              schemeDuration: schemeYear[index].storageType!,
                              selection: schemeYear[index].schemeplanID!,
                            );
                          },
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          );
        },
        error: (error,stack)=>Center(child: Text('error',style: getRegularStyle(color: ColorManager.black),),),
        loading: ()=>buildShimmerEffect()
    );


  }





  Widget _buildSubscriptionTile({
    required VoidCallback onTap,
    required String schemeName,
    required int schemePrice,
    required int schemeDuration,
    required int selection,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        elevation: schemePlanId == selection?3:0,
        child: ListTile(
          onTap: onTap,
          tileColor:schemePlanId == selection? ColorManager.primary.withOpacity(0.1):ColorManager.white ,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  color: schemePlanId == selection?ColorManager.primary:ColorManager.black.withOpacity(0.5),
                  width: schemePlanId == selection?1:0.5
              )
          ),
          leading: Text('$schemeName',style: getMediumStyle(color: selectSubscription == selection?ColorManager.black:ColorManager.black.withOpacity(0.5),fontSize: 20),),
          trailing: Text(schemePrice==0?'Free':'Rs.$schemePrice per ${schemeDuration ==1 ? 'month': 'year'}',style: getRegularStyle(color: selectSubscription == selection?ColorManager.black:ColorManager.black.withOpacity(0.5),fontSize: 18),),
        ),
      ),
    );
  }

  Widget _buildSubBanner({
    required String schemeName,
    required int schemePrice,
    String? schemeDuration,
    required int selectSubscription,
    required Color gradient,

  }) {
    return CustomBannerShimmer(
        width: 340.w,
        height: 200,
        borderRadius: 20,
        gradient: gradient,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            schemeDuration!=null?Text('$schemeName',style: getBoldStyle(color: ColorManager.white,fontSize: 20),):Text('Trial',style: getBoldStyle(color: ColorManager.white,fontSize: 20),),
            h20,
            schemeDuration != null?
            schemePrice != 0?
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Rs. ',style: getMediumStyle(color: ColorManager.white,fontSize: 16),),
                Text('$schemePrice',style: getMediumStyle(color: ColorManager.white,fontSize: 36),),
                w10,
                Text('for a $schemeDuration',style: getMediumStyle(color: ColorManager.white,fontSize: 18),),
              ],
            )
                :Text('Free for a 15 days',style: getMediumStyle(color: ColorManager.white,fontSize: 20),)
                :Text('$schemeName',style: getMediumStyle(color: ColorManager.white,fontSize: 30),),
            h12,
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.check,color: ColorManager.white,size: 12,),
                w10,
                Text('Access to new features',style: getMediumStyle(color: ColorManager.white,fontSize: 16),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.check,color: ColorManager.white,size: 12,),
                w10,
                Text('features 2',style: getMediumStyle(color: ColorManager.white,fontSize: 14),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.check,color: ColorManager.white,size: 12,),
                w10,
                Text('features 3',style: getMediumStyle(color: ColorManager.white,fontSize: 14  ),),
              ],
            ),


          ],
        )
    );



  }

}



/// Banner Shimmer animation.....

class CustomBannerShimmer extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color gradient;
  final Widget child;

  const CustomBannerShimmer({
    Key? key,
    required this.width,
    required this.height,
    this.borderRadius = 0.0,
    required this.gradient,
    required this.child
  }) : super(key: key);

  @override
  CustomBannerShimmerState createState() => CustomBannerShimmerState();
}

class CustomBannerShimmerState extends State<CustomBannerShimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _gradientPosition;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(

      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    _gradientPosition = Tween<double>(begin: -2.0, end:2.0).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Card(
        color: Colors.transparent,
        elevation: 5,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [
                widget.gradient,
                ColorManager.white,
                widget.gradient,
              ],
              stops: const [0.0, 0.5, 0.8],
              begin: FractionalOffset(_gradientPosition.value, 0.0),
              end: FractionalOffset(2.0 + _gradientPosition.value, 2.0 + _gradientPosition.value),
            ),
          ),
          child: Container(
            height: widget.height,
            width: widget.width,
            padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.w),
            decoration: BoxDecoration(
              color: widget.gradient.withOpacity(0.6),
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double gradientTranslation(double begin, double end) {
    return (begin + (end - begin) * _gradientPosition.value + 1.0) / 3.0 * widget.width;
  }
}
