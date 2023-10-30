


import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';
import 'package:medical_app/src/core/resources/style_manager.dart';
import 'package:medical_app/src/presentation/notification/presentation/notification_page.dart';

import '../../../../core/resources/value_manager.dart';
import '../../../login/domain/model/user.dart';
import '../../../login/domain/service/login_service.dart';
import '../../../login/presentation/status_page.dart';
import '../../documents/presentation/document_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context,ref) {

    final screenSize = MediaQuery.of(context).size;

    bool isNarrowScreen = screenSize.width < 380;
    bool isWideScreen = screenSize.width > 560;


    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    String mobileNo = userBox[0].contactNo!;
    String email = userBox[0].email!;
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
              onPressed:()=>Get.to(()=>NotificationPage()),
              icon: FaIcon(Icons.notifications,color: ColorManager.white,))
        ],

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeIn(
              duration: Duration(milliseconds: 500),
              child: profileBanner(context)),
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
                        Row(
                          children: [
                            Expanded(
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
                            Expanded(
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
                                    Text(email.length > 17? '${email.substring(0,18)}...':email,style: getRegularStyle(color: ColorManager.black,fontSize: 16),maxLines: 1,overflow: TextOverflow.ellipsis,),

                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        h10,

                        // _profileItems2(title: 'Phone Number', icon: FontAwesomeIcons.phone, onTap: (){},subtitle: '98XXXXXXXX'),
                        // _profileItems2(title: 'E-Mail', icon: Icons.email_outlined, onTap: (){},subtitle: 'user@gmail.com'),
                        _profileItems2(title: 'My Documents', icon: FontAwesomeIcons.folderClosed, onTap: (){
                          Get.to(()=>PatientDocumentPage(isWideScreen,isNarrowScreen));
                        },trailing: true),
                        _profileItems2(title: 'Change Password', icon: FontAwesomeIcons.key, onTap: (){},trailing: true),
                        _profileItems2(title: 'Permissions', icon: FontAwesomeIcons.universalAccess, onTap: (){},trailing: true),
                        _profileItems2(title: 'Help Center', icon: Icons.question_mark, onTap: (){},trailing: true),
                        _profileItems2(title: 'Terms & Policies', icon: FontAwesomeIcons.book, onTap: (){},trailing: true),
                        _profileItems2(
                            title: 'Log out',
                            icon: Icons.login_outlined,
                            onTap: () {
                              ref.read(userProvider.notifier).userLogout();
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
  
  Widget profileBanner(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    bool isNarrowScreen = screenSize.width < 420;

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;





    return Card(
      elevation: 1,
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
                  shape: CircleBorder(),
                  elevation: 5,
                  child: CircleAvatar(
                    backgroundColor: ColorManager.white,
                    radius: isNarrowScreen? 50.r:50,
                    child: CircleAvatar(
                      backgroundColor: ColorManager.black,
                      radius: isNarrowScreen? 45.r:45,
                      child: FaIcon(FontAwesomeIcons.person,color: ColorManager.white,),
                    ),
                  ),
                ),
                w10,
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('$firstName',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 32.sp:32),),
                    h10,
                    Row(
                      children: [
                        Text('Gender',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                        w10,
                        Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?12.sp:12),),
                        w10,
                        Text('23 yrs',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                        w10,
                        Text('|',style: getRegularStyle(color: ColorManager.textGrey,fontSize:isNarrowScreen?12.sp: 12),),
                        w10,
                        Text('Address',style: getRegularStyle(color: ColorManager.textGrey,fontSize: isNarrowScreen?16.sp:16),),
                      ],
                    )
                  ],
                ),
              ],
            ),
            w10,
            FaIcon(FontAwesomeIcons.penToSquare,color: ColorManager.primaryDark,)
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
