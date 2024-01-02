


import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/change_password_doc_org/presentation/change_password.dart';
import 'package:meroupachar/src/presentation/doctor/profile/presentation/widgets/update_profile.dart';
import 'package:meroupachar/src/presentation/notification/presentation/notification_page.dart';

import '../../../../core/api.dart';
import '../../../../core/resources/value_manager.dart';
import '../../../../data/model/country_model.dart';
import '../../../../data/provider/common_provider.dart';
import '../../../../data/services/country_services.dart';
import 'package:meroupachar/src/presentation/login/domain/model/user.dart';
import '../../../login/domain/service/login_service.dart';
import '../../../login/presentation/status_page.dart';

class DocProfilePage extends ConsumerStatefulWidget {
  final User user;
  DocProfilePage(this.user);

  @override
  ConsumerState<DocProfilePage> createState() => _DocProfilePageState();
}

class _DocProfilePageState extends ConsumerState<DocProfilePage> {


  List<DistrictModel> districts = [];


  List<MunicipalityModel> municipalities = [];

  String mun = '';
  String district = '';


  final ScrollController _scrollController = ScrollController();




  @override
  void initState(){
    super.initState();

    // Add a post-frame callback to scroll to the end after the layout is built
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollToEnd();
    });
    _getDistrict();
    _getMunicipality();
  }


  // Function to scroll to the end and back once
  void _scrollToEnd() async {
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.linear,
    );

    await Future.delayed(Duration(seconds: 1)); // Wait for a second

    await _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.linear,
    );
  }



  /// fetch district list...

  void _getDistrict() async {

    List<DistrictModel> districtList = await CountryService().getAllDistrict();
    setState(() {
      districts = districtList;

      district = districts.firstWhere((element) => element.districtId == widget.user.districtID).districtName;

    });
  }


  /// fetch municipality list...

  void _getMunicipality() async {

    List<MunicipalityModel> municipalityList = await CountryService().getAllMunicipality();
    setState(() {
      municipalities = municipalityList;
      mun = municipalities.firstWhere((element) => element.municipalityId == widget.user.municipalityID).municipalityName;
    });
  }




  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.of(context).size;
    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    String mobileNo = userBox[0].contactNo!;
    String email = userBox[0].email!;
    String license = userBox[0].liscenceNo!;
    String address = userBox[0].localAddress!;
    String ward = userBox[0].wardNo!.toString();

    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.99),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.primaryDark,
        automaticallyImplyLeading: false,
        title: Text('Profile',style: getMediumStyle(color: ColorManager.white),),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed:()=>Get.to(()=>NotificationPage(code: userBox[0].code!,)),
              icon: FaIcon(Icons.notifications,color: ColorManager.white,))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeIn(
              duration: Duration(milliseconds: 500),
              child: profileBanner(context,ref)),
          Container(
            height: MediaQuery.of(context).size.height * 3.5/5,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        h10,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          child: Row(
                            children: [
                              InkWell(
                                onDoubleTap: (){
                                  Clipboard.setData(ClipboardData(text: mobileNo));
                                  Fluttertoast.showToast(
                                      msg: "Phone number copied",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black.withOpacity(0.1),
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: ColorManager.black.withOpacity(0.2)
                                      // ),
                                      color: ColorManager.textGrey.withOpacity(0.05)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.phone,color: ColorManager.primaryDark,),
                                      w20,
                                      Text(mobileNo,style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                                    ],
                                  ),
                                ),
                              ),
                              w10,
                              InkWell(
                                onDoubleTap: (){
                                  Clipboard.setData(ClipboardData(text: email));
                                  Fluttertoast.showToast(
                                      msg: "Email copied",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.black.withOpacity(0.1),
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      // border: Border.all(
                                      //   color: ColorManager.black.withOpacity(0.2)
                                      // ),
                                      color: ColorManager.textGrey.withOpacity(0.05)
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      FaIcon(Icons.email_outlined,color: ColorManager.primaryDark,),
                                      w20,
                                      Text(email,style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),maxLines: 1,overflow: TextOverflow.ellipsis,),
                                    ],
                                  ),
                                ),
                              ),
                              w10,
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: ColorManager.black.withOpacity(0.2)
                                    // ),
                                    color: ColorManager.textGrey.withOpacity(0.05)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(Icons.pin_drop_outlined,color: ColorManager.primaryDark,),
                                    w20,
                                    Text('${mun}-${ward}, ${district}, ${address}',style: getRegularStyle(color: ColorManager.black,fontSize: 18.sp),maxLines: 1,overflow: TextOverflow.ellipsis,),

                                  ],
                                ),
                              ),
                              w10,
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: ColorManager.black.withOpacity(0.2)
                                    // ),
                                    color: ColorManager.textGrey.withOpacity(0.05)
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 18.w,vertical: 12.h),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    FaIcon(FontAwesomeIcons.driversLicense,color: ColorManager.primaryDark,),
                                    w20,
                                    Text(license,style: getRegularStyle(color: ColorManager.black,fontSize: 14.sp),maxLines: 1,overflow: TextOverflow.ellipsis,),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        h10,
                        _profileItems2(title: 'Education & Experiences', icon: FontAwesomeIcons.graduationCap, onTap: (){},trailing: true),
                        _profileItems2(title: 'Certifications', icon: FontAwesomeIcons.certificate, onTap: (){},trailing: true),
                        _profileItems2(title: 'Patient Reviews (253)', icon: FontAwesomeIcons.solidStar, onTap: (){},trailing: true),
                        _profileItems2(title: 'Change Password', icon: FontAwesomeIcons.key,
                            onTap: ()=>Get.to(()=>ChangePwdDocOrg(userBox.first)),
                            trailing: true),
                        _profileItems2(title: 'Permissions', icon: FontAwesomeIcons.universalAccess, onTap: (){},trailing: true),
                        _profileItems2(title: 'Help Center', icon: Icons.question_mark, onTap: (){},trailing: true),
                        _profileItems2(title: 'Terms & Policies', icon: FontAwesomeIcons.book, onTap: (){},trailing: true),
                        _profileItems2(
                            title: 'Log out',
                            icon: Icons.login_outlined,
                            onTap: () {
                              ref.read(userProvider.notifier).userLogout();
                              ('logout');
                              Get.offAll(() => StatusPage(accountId: 0,));
                            }
                        ),
                      ],
                    ),
                  ),

                  h20,
                  h20,
                  h20,
                  Container(

                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Version 1.0.0',style: getRegularStyle(color: ColorManager.black,fontSize: 16),),
                          h10,
                          Text('Developed by Search Technology',style: getMediumStyle(color: ColorManager.black,fontSize: 16),),
                          h10,

                        ],
                      ),
                    ),
                  ),
                  h100,




                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Profile...

  Widget profileBanner(BuildContext context,ref) {
    final screenSize = MediaQuery.of(context).size;

    bool isNarrowScreen = screenSize.width < 420;
    bool isWideScreen = screenSize.width > 560;

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    String lastName = userBox[0].lastName!;
    final profileImg = ref.watch(imageProvider);
    ImageProvider<Object>? profileImage;

    if (profileImg != null) {
      profileImage = Image.file(File(profileImg.path)).image;
    } else if (userBox[0].profileImage == null) {
      profileImage = AssetImage('assets/icons/user.png');
    } else {
      profileImage = NetworkImage('${Api.baseUrl}/${userBox[0].profileImage}');
    }





    return Card(
      elevation: 1,
      color: ColorManager.white,
      shadowColor: ColorManager.textGrey.withOpacity(0.4),
      child: Container(

        padding: EdgeInsets.symmetric(horizontal: 18.w,vertical:12.h),
        child:  Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Card(
                  shape: CircleBorder(
                      side: BorderSide(
                          color: ColorManager.white,
                          width: 1
                      )
                  ),
                  child: CircleAvatar(
                    backgroundColor: ColorManager.white,
                    backgroundImage: profileImage,
                    radius: 30,
                  ),
                ),
                w10,
                Text('$firstName $lastName',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 26.sp:26),),
              ],
            ),
            w10,
            InkWell(
                onTap: ()=>Get.to(()=>UpdateDocProfile(isWideScreen,isNarrowScreen,userBox[0])),
                child: FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.primaryDark,))
          ],
        ),
      ),
    );
  }

  /// Profile items func & ui ...
//
//   Widget _profileItems({
//     VoidCallback? onTap,
//     required String title,
//     required IconData icon,
//     String? subtitle,
//     bool? trailing,
//     required Size screenSize
//
// }) {
//
//     // Check if width is greater than height
//     bool isWideScreen = screenSize.width > 500;
//     bool isNarrowScreen = screenSize.width < 420;
//     if(trailing == null){
//      trailing = false;
//     }
//     return ListTile(
//       onTap: onTap,
//       splashColor: ColorManager.textGrey.withOpacity(0.2),
//       leading: FaIcon(icon,size: isNarrowScreen?24.sp:24,),
//       title: Text('$title',style:getRegularStyle(color: ColorManager.black,fontSize:isNarrowScreen?20.sp:20 ),),
//       subtitle: subtitle != null? Text('$subtitle',style:getRegularStyle(color: ColorManager.subtitleGrey,fontSize:isNarrowScreen?16.sp:16 ),):null,
//       trailing: trailing == true? Icon(Icons.chevron_right,color: ColorManager.iconGrey,):null ,
//     );
//   }


  Widget _profileItems2({
    VoidCallback? onTap,
    required String title,
    required IconData icon,
    String? subtitle,
    bool? trailing,
  }) {
    if (trailing == null) {
      trailing = false;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(5)
        ),
        onTap: onTap, // Pass the onTap callback here
        splashColor: ColorManager.textGrey.withOpacity(0.2),
        tileColor: ColorManager.textGrey.withOpacity(0.05),
        leading: FaIcon(icon, size: 20,color: ColorManager.primaryDark,),
        title: Text('$title', style: getRegularStyle(color: ColorManager.black, fontSize: 18),),
        subtitle: subtitle != null ? Text('$subtitle', style: getRegularStyle(color: ColorManager.subtitleGrey, fontSize: 14),) : null,
        trailing: trailing == true ? Icon(Icons.chevron_right, color: ColorManager.iconGrey,) : null,
      ),
    );
  }
}
