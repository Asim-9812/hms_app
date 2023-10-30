



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../core/resources/color_manager.dart';
import '../../core/resources/style_manager.dart';
import '../../core/resources/value_manager.dart';
import '../login/domain/service/login_service.dart';
import '../login/presentation/status_page.dart';

class Settings extends ConsumerWidget {
  final bool isWideScreen;
  final bool isNarrowScreen;
  Settings(this.isWideScreen,this.isNarrowScreen);

  @override
  Widget build(BuildContext context,ref) {
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.99),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: ColorManager.white,
        title: Text('Settings',style: getMediumStyle(color: ColorManager.black,fontSize: isNarrowScreen? 24.sp:28),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            h20,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileItems(title: 'Change Password', icon: FontAwesomeIcons.key, onTap: (){},trailing: true),
                  _profileItems(title: 'Permissions', icon: FontAwesomeIcons.universalAccess, onTap: (){},trailing: true),
                  _profileItems(title: 'Help Center', icon: Icons.question_mark, onTap: (){},trailing: true),
                  _profileItems(title: 'Terms & Policies', icon: FontAwesomeIcons.book, onTap: (){},trailing: true),
                  _profileItems(
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
    );
  }

  Widget _profileItems({
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
        onTap: onTap, // Pass the onTap callback here
        splashColor: ColorManager.textGrey.withOpacity(0.2),
        tileColor: ColorManager.textGrey.withOpacity(0.05),
        leading: FaIcon(icon, size: 20,),
        title: Text('$title', style: getRegularStyle(color: ColorManager.black, fontSize: 18),),
        subtitle: subtitle != null ? Text('$subtitle', style: getRegularStyle(color: ColorManager.subtitleGrey, fontSize: 14),) : null,
        trailing: trailing == true ? Icon(Icons.chevron_right, color: ColorManager.iconGrey,) : null,
      ),
    );
  }


}
