
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';

import '../../login/domain/model/user.dart';
import '../domain/services/jitsi_provider.dart';



class CreateMeeting extends ConsumerStatefulWidget {
  const CreateMeeting({super.key});

  @override
  ConsumerState<CreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends ConsumerState<CreateMeeting> {
  JitsiProvider? _jitsiProvider ;
  TextEditingController _roomController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    _jitsiProvider = ref.read(jitsiProvider);
    final userBox = Hive.box<User>('session').values.toList();
    String firstName = userBox[0].firstName!;
    String email = userBox[0].email!;
    return Scaffold(
      backgroundColor: ColorManager.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text('Create a Meeting',style: TextStyle(color: ColorManager.white),),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        leading: IconButton(
            onPressed: ()=>Get.back(),
            icon: FaIcon(CupertinoIcons.chevron_back,color: ColorManager.white,)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            TextFormField(
              controller: _roomController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.white,
                  labelText: 'Room Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.white
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.white
                      )
                  )
              ),
              validator: (value){
                if(value!.trim().isEmpty){
                  return 'Room name is required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            const SizedBox(height: 10,),
            TextFormField(
              controller: _subjectController,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: ColorManager.white,
                  labelText: 'Subject (Optional)',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.white
                      )
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: ColorManager.white
                      )
                  )
              ),
              validator: (value){

                RegExp regExp = RegExp(r'^[a-zA-Z0-9 ]+$');
                if (!regExp.hasMatch(value!)) {
                  return 'Invalid characters in Subject Name';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,

            ),
            const SizedBox(height: 10,),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primary,
                    shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
                onPressed: (){
                  _jitsiProvider?.createMeeting(
                      roomName: _roomController.text.trim(),
                      isAudioMuted: true,
                      isVideoMuted: true,
                      username: firstName,
                      email: email,
                      subject:_subjectController.text.isNotEmpty? _subjectController.text.trim(): _roomController.text.trim()
                  );
                },
                child: Text('Create a room',style: TextStyle(color: ColorManager.white),))
          ],
        ),
      ),
    );
  }
}
