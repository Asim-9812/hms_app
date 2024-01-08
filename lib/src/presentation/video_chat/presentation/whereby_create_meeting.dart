
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/presentation/video_chat/domain/model/whereby_models.dart';
import 'package:meroupachar/src/presentation/video_chat/domain/services/whereby_services.dart';
import 'package:meroupachar/src/presentation/video_chat/presentation/whereby_meeting_page.dart';

import '../../common/snackbar.dart';
import '../../login/domain/model/user.dart';



class WherebyCreateMeeting extends ConsumerStatefulWidget {
  const WherebyCreateMeeting({super.key});

  @override
  ConsumerState<WherebyCreateMeeting> createState() => _CreateMeetingState();
}

class _CreateMeetingState extends ConsumerState<WherebyCreateMeeting> {

  TextEditingController _roomController = TextEditingController();
  TextEditingController _subjectController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  
  var _url = '';

  bool isPosting = false;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
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
          child: Form(
            key: _formKey,
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
                    else if(value.contains(' ')){
                     return 'Room name cant contain space';
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
                    onPressed:isPosting? null : ()async{
                      final scaffoldMessage = ScaffoldMessenger.of(context);

                      if(_formKey.currentState!.validate()){
                        setState(() {
                          isPosting = true;
                        });
                        CreateMeetingModel newData = CreateMeetingModel(isLocked: false, roomNamePrefix: _roomController.text.trim(), roomNamePattern: 'human-short', roomMode: 'normal', endDate: DateTime.now().add(Duration(days: 1)), fields: []);
                        final response = await MeetingServices().CreateMeeting(data: newData);
                        if(response.isLeft()){
                          final value = response.fold((l) => l, (r) => null);
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showFailureSnackbar(
                                message: '$value',
                                duration: const Duration(seconds: 2)
                            ),
                          );
                          setState(() {
                            isPosting = false;
                          });

                        }else{
                          final right = response.fold((l) => null, (r) => r);
                          scaffoldMessage.showSnackBar(
                            SnackbarUtil.showSuccessSnackbar(
                                message: 'Meeting created',
                                duration: const Duration(seconds: 2)
                            ),
                          );
                          setState(() {
                            _url =  right!.roomUrl;
                          });

                          Get.to(()=>WhereByMeetingPage(_url));
                          setState(() {
                            isPosting = false;
                          });

                        }
                      }


                    },
                    child:isPosting ? SpinKitDualRing(color: Colors.white,size: 16,): Text('Create a room',style: TextStyle(color: ColorManager.white),))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
