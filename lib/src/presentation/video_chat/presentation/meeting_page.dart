import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';

import '../../login/domain/model/user.dart';
import '../domain/services/jitsi_provider.dart';
import 'create_meeting.dart';


class MeetingPage extends ConsumerStatefulWidget {
  const MeetingPage({super.key});

  @override
  ConsumerState<MeetingPage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<MeetingPage> {

  JitsiProvider? _jitsiProvider ;

  TextEditingController _roomController = TextEditingController();

  bool elevate = false;
  bool elevate1= false;


  void _joinDialog() async {

    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    String email = userBox[0].email!;
    await showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor:ColorManager.white,
            content: Container(
              decoration: BoxDecoration(
                color:ColorManager.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 18,vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Join A Room',style: getMediumStyle(color: Colors.black,fontSize: 20),),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: _roomController,
                    decoration: InputDecoration(
                      fillColor:ColorManager.white,
                      filled: true,
                      hintText: 'Enter a room name',
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
                          _jitsiProvider?.createMeeting(
                            roomName: _roomController.text,
                            isAudioMuted: true,
                            isVideoMuted: true,
                            username: firstName,
                            email: email,
                          );
                          Navigator.pop(context);
                        }, child: Text('Join',style: getMediumStyle(color:ColorManager.white,fontSize: 20),)),
                  )
                ],
              ),
            ),
          );
        }
    );
  }




  @override
  Widget build(BuildContext context) {

    _jitsiProvider = ref.read(jitsiProvider);

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
                onPressed: ()=>Get.to(()=>CreateMeeting()),
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

                  _joinDialog();

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
