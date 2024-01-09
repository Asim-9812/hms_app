import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/whereby_create_meeting.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/whereby_join_page.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/whereby_meeting_page.dart';
import '../../login/domain/model/user.dart';


class MeetingPage extends ConsumerStatefulWidget {
  const MeetingPage({super.key});

  @override
  ConsumerState<MeetingPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MeetingPage> {

  TextEditingController _roomController = TextEditingController();





  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor:ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Meeting',style: getMediumStyle(color:ColorManager.white),),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(CupertinoIcons.chevron_back,color: ColorManager.white,)),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    elevation: 0,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18)
                ),
                onPressed: ()=>Get.to(()=>WherebyCreateMeeting()),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.video_call_rounded,color:ColorManager.white,size: 30,),
                    const SizedBox(width: 10,),
                    Text('Create a Meeting',style: getMediumStyle(color:ColorManager.white,fontSize: 20),),
                  ],
                )),
            const SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: CupertinoColors.white,
                    elevation: 0,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal: 18)
                ),

                onPressed: ()  {

                  Get.to(()=>WhereByJoinMeetingPage());

                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(CupertinoIcons.videocam_fill,color: ColorManager.primary,size: 30,),
                    const SizedBox(width: 10,),
                    Text('Join a Meeting',style: getMediumStyle(color: ColorManager.primary,fontSize: 20),),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
