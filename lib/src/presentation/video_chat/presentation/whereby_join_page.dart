


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/whereby_meeting_page.dart';

import '../../../core/resources/color_manager.dart';
import '../../../core/resources/style_manager.dart';

class WhereByJoinMeetingPage extends StatelessWidget {

  final _roomController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Join a Meeting',style: getMediumStyle(color:ColorManager.white),),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(CupertinoIcons.chevron_back,color: ColorManager.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _roomController,
              decoration: InputDecoration(
                fillColor:ColorManager.white,
                filled: true,
                hintText: 'Enter a room url',
                hintStyle: getRegularStyle(color: Colors.black.withOpacity(0.7),fontSize: 20,),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )
                ),
                focusColor: Colors.black,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )
                ),
              ),
              style: getMediumStyle(color: Colors.black,fontSize: 25),
            ),
            const SizedBox(height: 10,),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primary,
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                  onPressed: (){
                    Get.to(()=>WhereByMeetingPage(_roomController.text.trim()));
                  }, child: Text('Join',style: getMediumStyle(color:ColorManager.white,fontSize: 20),)),
            )
          ],
        ),
      ),
    );
  }
}
