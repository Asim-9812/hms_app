import 'package:carousel_slider/carousel_slider.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/subscription-plan/domain/scheme_service.dart';
import '../../../core/api.dart';
import '../../../core/resources/style_manager.dart';
import '../../../core/resources/value_manager.dart';
import '../../../data/services/payment_services.dart';
import '../../common/snackbar.dart';
import '../../login/presentation/login_page.dart';
import '../../register/domain/register_model/register_model.dart';
import '../domain/scheme_model.dart';




class DoctorSubscriptionPlan extends ConsumerStatefulWidget {
  final RegisterDoctorModel registerDoctorModel;
  DoctorSubscriptionPlan({required this.registerDoctorModel});

  @override
  ConsumerState<DoctorSubscriptionPlan> createState() => _SubscriptionPlanTestState();
}

class _SubscriptionPlanTestState extends ConsumerState<DoctorSubscriptionPlan> {



  PageController _controller = PageController();
  final CarouselController _carouselController = CarouselController();
  int _currentSlide = 0;
  int selectedPage = 0;
  Map<String,dynamic> outputValue = {};
  final dio = Dio();
  bool isPostingData = false;
  int paymentOption = 0;
  int selectedPayment = 2;
  SchemePlaneModel? schemePlan;


  Color? getPaymentContainerColor(int paymentOption) {
    return selectedPayment == paymentOption ? ColorManager.primary : null;
  }





  Future<dartz.Either<String, dynamic>> docRegister() async {
    print('docRegister: ${widget.registerDoctorModel.password}');
    try {
      final response = await dio.post(
          Api.registerDoctor,
          data: {
            "doctorID": 0,
            "docID": "",
            "firstName": widget.registerDoctorModel.firstName,
            "lastName": widget.registerDoctorModel.lastName,
            "doctorEmail":widget.registerDoctorModel.email,
            "doctorPassword": widget.registerDoctorModel.password,
            "code":widget.registerDoctorModel.code,
            "roleID": 2,
            "referenceNo": "1",
            "subscriptionID": 0,
            "isActive": true,
            "entryDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
            "genderID": widget.registerDoctorModel.genderId,
            "key": "12",
            "flag": "Insert"
          }

      );

      setState(() {
        outputValue = response.data;
      });



      return dartz.Right(response.data);
    } on DioException catch (err) {
      print('error message : $err');
      throw Exception('${err.response!.data}');
    }}



  Future<dartz.Either<String, dynamic>> subscriptionPlanDoctor({

    required int schemePlanId,
    required int schemeId,
  }) async {
    print('subscriptionPlanDoctor: ${widget.registerDoctorModel.password}');
    try {
      final response = await dio.post(
          Api.subscriptionPlan,
          data: {
            "id": 0,
            "userid": '${outputValue['result']['docID']}',
            "schemeId" : schemeId,
            "subscriptionID": schemePlanId,
            "fromDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "toDate": schemePlan!.schemeId == 1
                ? "${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 15))).toString()}"
                :schemePlan!.storageType==1
                ?"${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 30))).toString()}"
                :"${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: 365))).toString()}",
            "flag": ""
          }
      );

      (response.data);
      return dartz.Right(response.data);
    } on DioException catch (err) {
      print(err.response);


      throw Exception('${err.response!.data['message']}');
    }}



  Future<dartz.Either<String, dynamic>> userRegisterDoctor() async {
    print('userRegisterDoctor: ${widget.registerDoctorModel.password}');
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
            "natureID": widget.registerDoctorModel.natureId,
            "liscenceNo": 0,
            "email": widget.registerDoctorModel.email,
            "roleID": 2,
            "natureId" : widget.registerDoctorModel.natureId,
            "joinedDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "isActive": true,
            "genderID": widget.registerDoctorModel.genderId,
            "entryDate": "${DateFormat('yyyy-MM-dd').format(DateTime.now()).toString()}",
            "key": "12",
            "flag": "Register",
            "code":widget.registerDoctorModel.code
          }
      );


      return dartz.Right(response.data);
    } on DioException catch (err) {
      print(err.response);


      throw Exception('${err.response!.data['message']}');
    }}









  @override
  Widget build(BuildContext context) {

    final schemeList = ref.watch(schemeProvider);

    return schemeList.when(
        data: (data){
          if(data.isEmpty){
            return Scaffold(
              backgroundColor: ColorManager.primary.withOpacity(0.8),
              body: Center(
                child: Text('No Subscription plan',style: getBoldStyle(color: ColorManager.white),),
              ),
            );
          }
          return Scaffold(
            backgroundColor: ColorManager.primary.withOpacity(0.8),
            // appBar: AppBar(
            //   elevation: 0,
            //   backgroundColor: ColorManager.white,
            //   leading: IconButton(onPressed: ()=>Get.back(), icon: FaIcon(Icons.chevron_left,color: ColorManager.black,)),
            // ),
            body: SafeArea(
              child: Padding(
                padding:  EdgeInsets.symmetric(horizontal: 18.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select your',style: getRegularStyle(color: ColorManager.white,fontSize: 24),),
                    h10,
                    Text('Subscription\nPlan',style: getBoldStyle(color: ColorManager.white,fontSize: 50),textAlign: TextAlign.start,),
                    h10,
                    Expanded(
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _controller,
                        children: [
                          _mainBody(data: data.where((element) => element.storageType == 1
                            // && element.startDate!.isBefore(DateTime.now()) && element.endDate!.isAfter(DateTime.now())
                          ).toList(),),
                          _mainBody(data: data.where((element) => element.storageType == 2
                            //&& element.startDate!.isBefore(DateTime.now()) && element.endDate!.isAfter(DateTime.now())
                          ).toList(),)
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(10),

              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 12.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      _controller.previousPage(duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                      setState(() {
                        selectedPage = 0;

                        _currentSlide = 0;
                      });
                      _carouselController.jumpToPage(0);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: selectedPage == 0 ? ColorManager.primary : ColorManager.white,
                          borderRadius: BorderRadius.circular(10),

                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        child: Text('Monthly',style: getRegularStyle(color:selectedPage == 0 ? ColorManager.white : ColorManager.black),)),
                  ),
                  w20,
                  w20,
                  InkWell(
                    onTap: (){
                      _controller.nextPage(duration: Duration(milliseconds: 300), curve: Curves.fastOutSlowIn);
                      setState(() {
                        selectedPage = 1;

                        _currentSlide = 0;
                      });
                      _carouselController.jumpToPage(0);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: selectedPage == 1 ? ColorManager.primary:ColorManager.white,
                          borderRadius: BorderRadius.circular(10),

                        ),
                        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                        child: Text('Yearly',style: getRegularStyle(color:selectedPage == 1 ? ColorManager.white :ColorManager.black),)),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Row(
                children: [

                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorManager.white,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        onPressed: ()=>Get.back(), child: Text('Cancel',style: getRegularStyle(color: ColorManager.black,fontSize: 16),)),
                  ),
                  w10,
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: ColorManager.primary,
                            shape: ContinuousRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                            )
                        ),
                        onPressed: isPostingData
                            ? null
                            :() async {
                          final scaffoldMessage = ScaffoldMessenger.of(context);

                          if(schemePlan == null){
                            setState(() {
                              schemePlan = data.firstWhere((element) => element.schemeName!.toLowerCase() == 'free trial');
                            });
                          }
                          if(schemePlan!.schemeName?.toLowerCase() == 'free trial'){
                            setState(() {
                              isPostingData = true;
                            });
                            await docRegister().then((value) async {
                              if(value.isLeft()){
                                scaffoldMessage.showSnackBar(
                                  SnackbarUtil.showFailureSnackbar(
                                      message: 'Something went wrong',
                                      duration: const Duration(seconds: 2)
                                  ),
                                );
                              }
                              else{
                                await subscriptionPlanDoctor(schemePlanId: schemePlan!.schemeplanID!,schemeId: schemePlan!.schemeId!).then((value) async {
                                  print('subscriptionPlanDoctor register : $value');
                                  if(value.isLeft()){
                                    scaffoldMessage.showSnackBar(
                                      SnackbarUtil.showFailureSnackbar(
                                          message: 'Something went wrong',
                                          duration: const Duration(seconds: 2)
                                      ),
                                    );
                                    setState(() {
                                      isPostingData = false;
                                    });
                                  }
                                  else{
                                    await userRegisterDoctor().then((value) {
                                      print('userRegisterDoctor register : $value');
                                      if(value.isLeft()){
                                        scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showFailureSnackbar(
                                              message: 'Something went wrong',
                                              duration: const Duration(seconds: 2)
                                          ),
                                        );
                                        setState(() {
                                          isPostingData = false;
                                        });
                                      }else{
                                        scaffoldMessage.showSnackBar(
                                          SnackbarUtil.showSuccessSnackbar(
                                              message: 'User registered successfully',
                                              duration: const Duration(seconds: 2)
                                          ),
                                        );
                                        setState(() {
                                          isPostingData = false;
                                        });
                                        Get.offAll(() => LoginPage());
                                      }
                                    });

                                  }

                                });
                              }
                            });

                          }
                          else{
                            scaffoldMessage.showSnackBar(
                              SnackbarUtil.showComingSoonBar(
                                  message: 'Coming soon',
                                  duration: const Duration(seconds: 2)
                              ),
                            );
                          }
                          // else{
                          //   await docRegister().then((value) async {
                          //     if(value.isLeft()){
                          //       scaffoldMessage.showSnackBar(
                          //         SnackbarUtil.showFailureSnackbar(
                          //             message: 'Something went wrong',
                          //             duration: const Duration(seconds: 2)
                          //         ),
                          //       );
                          //     }
                          //     else{
                          //       print('doc register : $value');
                          //       await  showModalBottomSheet(
                          //         context: context,
                          //         builder: (context) {
                          //
                          //
                          //           return StatefulBuilder(
                          //               builder: (context,setState) {
                          //                 return Container(
                          //                   padding: EdgeInsets.all(16),
                          //                   child: Column(
                          //                     mainAxisSize: MainAxisSize.min,
                          //                     children: [
                          //                       Row(
                          //                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //                         children: [
                          //                           // InkWell(
                          //                           //   onTap:(){
                          //                           //     setState(() {
                          //                           //       selectedPayment = 1;
                          //                           //     });
                          //                           //   },
                          //                           //   child: Container(
                          //                           //     decoration: BoxDecoration(
                          //                           //         borderRadius: BorderRadius.circular(10),
                          //                           //         color: getPaymentContainerColor(1),
                          //                           //         border: Border.all(
                          //                           //             color: ColorManager.black.withOpacity(0.5)
                          //                           //         )
                          //                           //     ),
                          //                           //     padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                          //                           //     child: Column(
                          //                           //       mainAxisSize: MainAxisSize.min,
                          //                           //       mainAxisAlignment: MainAxisAlignment.center,
                          //                           //       crossAxisAlignment: CrossAxisAlignment.center,
                          //                           //       children: [
                          //                           //         Image.asset('assets/images/esewa.png',height: 30,fit: BoxFit.contain,),
                          //                           //         h10,
                          //                           //         Text('E-sewa',style: getRegularStyle(color: ColorManager.black),),
                          //                           //       ],
                          //                           //     ),
                          //                           //   ),
                          //                           // ),
                          //                           InkWell(
                          //                             onTap:(){
                          //                               setState(() {
                          //                                 selectedPayment = 2;
                          //                               });
                          //                             },
                          //                             child: Container(
                          //                               decoration: BoxDecoration(
                          //                                   borderRadius: BorderRadius.circular(10),
                          //                                   color: getPaymentContainerColor(2),
                          //                                   border: Border.all(
                          //                                       color: ColorManager.black.withOpacity(0.5)
                          //                                   )
                          //                               ),
                          //                               padding: EdgeInsets.symmetric(horizontal: 24,vertical: 18),
                          //                               child: Column(
                          //                                 mainAxisSize: MainAxisSize.min,
                          //                                 mainAxisAlignment: MainAxisAlignment.center,
                          //                                 crossAxisAlignment: CrossAxisAlignment.center,
                          //                                 children: [
                          //                                   Image.asset('assets/images/khalti.png',height: 30,fit: BoxFit.contain,),
                          //                                   h10,
                          //                                   Text('Khalti',style: getRegularStyle(color: ColorManager.black),),
                          //                                 ],
                          //                               ),
                          //                             ),
                          //                           ),
                          //                         ],
                          //                       ),
                          //                       SizedBox(height: 16),
                          //                       ElevatedButton(
                          //                         style: ElevatedButton.styleFrom(
                          //                             backgroundColor: ColorManager.primary,
                          //                             fixedSize: Size.fromWidth(300)
                          //
                          //                         ),
                          //                         onPressed: isPostingData
                          //                             ? null // Disable the button while posting data
                          //                             : () async {
                          //                           setState(() {
                          //                             isPostingData = true; // Show loading spinner
                          //                           });
                          //                           if(selectedPayment == 1){
                          //                             Navigator.pop(context);
                          //                             // payWithEsewaInApp(productId: outputValue['result']['docID'], amount: amount, schemePlanId: schemePlanId, schemePlanName: schemePlanName);
                          //                           }else if(selectedPayment ==2 ){
                          //                             Navigator.pop(context);
                          //                             payWithKhaltiInApp(outputValue: outputValue);
                          //
                          //                           }
                          //                           else {
                          //                             final scaffoldMessage = ScaffoldMessenger.of(context);
                          //                             scaffoldMessage.showSnackBar(
                          //                               SnackbarUtil.showFailureSnackbar(
                          //                                 message: 'Please select a payment option',
                          //                                 duration: const Duration(milliseconds: 1400),
                          //                               ),
                          //                             );
                          //                             setState(() {
                          //                               isPostingData = false; // Show loading spinner
                          //                             });
                          //                           }
                          //
                          //
                          //
                          //                         },
                          //                         child:isPostingData
                          //                             ?SpinKitDualRing(color: ColorManager.white,size: 20,)
                          //                             : Text('Select',style: getRegularStyle(color: ColorManager.white),),
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 );
                          //               }
                          //           );
                          //         },
                          //       );
                          //     }
                          //   });
                          // }



                        }, child: isPostingData ? Text('Please wait...',style: getRegularStyle(color: ColorManager.white,fontSize: 12),):Text('Submit',style: getRegularStyle(color: ColorManager.white,fontSize: 16),)),
                  ),
                ],
              ),
            ),
          );
        },
        error: (error,stack)=> Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(child: Text('Something went wrong',style: getSemiBoldStyle(color: ColorManager.white),),)),
        loading: ()=>Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(child: SpinKitDualRing(color: ColorManager.white,),))
    );


  }



  Widget _mainBody({
    required List<SchemePlaneModel> data
}){
    if(data.isEmpty){
      return Center(
        child: Text('No Subscription plan',style: getBoldStyle(color: ColorManager.white),),
      );
    }
    return Column(
      children: [
        CarouselSlider(

          items: data.map((e) =>
              _buildSubBanner(schemePlaneModel: e)
          )
              .toList(),
          carouselController: _carouselController,
          options: CarouselOptions(

            // height: 150,
            enlargeCenterPage: true,
            pageSnapping: true,
            autoPlay: false,
            // autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: true,
            // autoPlayAnimationDuration: Duration(milliseconds: 500),
            viewportFraction: 1,
            // autoPlayInterval:Duration(seconds: 5) ,
            onPageChanged: (index, reason) {
              // Update the current slide index when the page changes
              setState(() {
                _currentSlide = index;
              });
            },
          ),
        ),
        h20,
        _buildSubscriptionTile(data: data)

      ],
    );
  }


  Widget _buildSubscriptionTile({
    required List<SchemePlaneModel> data
}) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: false,
          itemCount: data.length,
          itemBuilder: (context , index){
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                elevation: 3,
                child: ListTile(
                  onTap: (){
                    setState(() {
                      schemePlan = data[index];
                      _currentSlide = index;
                      _carouselController.animateToPage(_currentSlide);
                    });
                  },
                  tileColor: _currentSlide ==  index ? ColorManager.primary.withOpacity(0.3):ColorManager.white ,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                          color:_currentSlide ==  index ? ColorManager.primary : ColorManager.black.withOpacity(0.5),
                          width: _currentSlide ==  index ? 3:1
                      )
                  ),
                  leading: Text(data[index].schemeName!,style: getMediumStyle(color: _currentSlide ==  index ? ColorManager.black : ColorManager.black.withOpacity(0.7),fontSize: 20),),
                  trailing: data[index].schemeName?.toLowerCase() == 'free trial' ? null :Text(data[index].storageType == 1 ? 'Rs. ${data[index].price!.round()} for a month' : 'Rs. ${data[index].price!.round()} for a year',style: getRegularStyle(color:_currentSlide ==  index ? ColorManager.black : ColorManager.black.withOpacity(0.7),fontSize: 16),),
                ),
              ),
            );
          }),
    );
  }


  Widget _buildSubBanner({
    required SchemePlaneModel schemePlaneModel

  }) {

   final Color color = schemePlaneModel.schemeName?.toLowerCase() == 'gold'
       ? ColorManager.goldContainer
       : schemePlaneModel.schemeName?.toLowerCase() == 'silver'
       ? ColorManager.silverContainer
       :  schemePlaneModel.schemeName?.toLowerCase() == 'free trial'
       ? ColorManager.primary
       : ColorManager.blackContainer ;

    return CustomBannerShimmer(
        width: 340.w,
        height: 200,
        borderRadius: 20,
        gradient: color,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(schemePlaneModel.schemeName!,style: getMediumStyle(color: ColorManager.white,fontSize: 30),),
            h10,
            if(schemePlaneModel.schemeName?.toLowerCase() != 'free trial')
            Row(
              children: [
                Text('Rs. ${schemePlaneModel.price!.round()}',style: getBoldStyle(color: ColorManager.white,fontSize: 45),),
                w10,
                Text('for a Month',style: getRegularStyle(color: ColorManager.white,fontSize: 25),),
              ],
            ),
            h10,
            Text('Access to new features',style: getRegularStyle(color: ColorManager.white,fontSize: 16),),


          ],
        )
    );



  }




  ///------------------------KHALTI SERVICES---------------------------///
  payWithKhaltiInApp({
    required Map<String, dynamic> outputValue,
  }){


    final config = PaymentConfig(
      amount: 1000, // Amount should be in paisa
      productIdentity: outputValue['result']['docID'],
      productName: schemePlan!.schemeName!,
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
      print('verification done');

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
        print('payment done');
        subscriptionPlanDoctor(
            schemePlanId: schemePlan!.schemeplanID!,
            schemeId: schemePlan!.schemeId!
        ).then((value) async {
          if (value.isLeft()) {
            scaffoldMessage.showSnackBar(
              SnackbarUtil.showFailureSnackbar(
                  message: 'Something went wrong',
                  duration: const Duration(seconds: 2)
              ),
            );
            setState(() {
              isPostingData = false;
            });
          }
          else {
            await userRegisterDoctor().then((value) {
              if(value.isLeft()){
                scaffoldMessage.showSnackBar(
                  SnackbarUtil.showFailureSnackbar(
                      message: 'Something went wrong',
                      duration: const Duration(seconds: 2)
                  ),
                );
                setState(() {
                  isPostingData = false;
                });
              }
              else{
                scaffoldMessage.showSnackBar(
                  SnackbarUtil.showSuccessSnackbar(
                      message: 'User registered successfully',
                      duration: const Duration(seconds: 2)
                  ),
                );
                setState(() {
                  isPostingData = false;
                });
                Get.offAll(() => LoginPage());
              }

            });
          }
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
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.w),
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

