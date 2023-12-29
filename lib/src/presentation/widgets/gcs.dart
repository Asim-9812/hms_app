import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:meroupachar/src/core/resources/color_manager.dart';
import 'package:meroupachar/src/core/resources/style_manager.dart';

import '../../core/resources/value_manager.dart';




class GCS extends StatefulWidget {
  @override
  _GcsTestScreenState createState() => _GcsTestScreenState();
}

class _GcsTestScreenState extends State<GCS> {
  int eyeResponse = 1;
  int verbalResponse = 1;
  int motorResponse = 1;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: ColorManager.primary,
        title: Text('GCS Score'),
        titleTextStyle: getMediumStyle(color: ColorManager.white),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()=>Get.back(),
          icon: FaIcon(Icons.chevron_left,color: ColorManager.white,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Eye Opening Response:',style: getMediumStyle(color: ColorManager.black),),
              h10,
              Text('The patient\'s ability to open their eyes spontaneously or in response to stimuli.',style: getRegularStyle(color: ColorManager.black,fontSize: 18),),
              h10,
              Column(
                children: [
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Spontaneous'),
                    value: 4,
                    groupValue: eyeResponse,
                    onChanged: (value) {
                      setState(() {
                        eyeResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('To speech'),
                    value: 3,
                    groupValue: eyeResponse,
                    onChanged: (value) {
                      setState(() {
                        eyeResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('To pain'),
                    value: 2,
                    groupValue: eyeResponse,
                    onChanged: (value) {
                      setState(() {
                        eyeResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('No response'),
                    value: 1,
                    groupValue: eyeResponse,
                    onChanged: (value) {
                      setState(() {
                        eyeResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Not testable'),
                    value: 0,
                    groupValue: eyeResponse,
                    onChanged: (value) {
                      setState(() {
                        eyeResponse = value!;
                      });
                    },
                  ),
                ],
              ),
              h20,
              Text('Verbal Response:',style: getMediumStyle(color: ColorManager.black),),
              h10,
              Text('The patient\'s ability to speak and respond verbally. This assesses their level of consciousness and orientation.',style: getRegularStyle(color: ColorManager.black,fontSize: 18),),
              h10,
              Column(
                children: [
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Orientated response'),
                    value: 5,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Confused conversation'),
                    value: 4,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Inappropriate words'),
                    value: 3,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Incomprehensible sounds'),
                    value: 2,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('No response'),
                    value: 1,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Not testable'),
                    value: 0,
                    groupValue: verbalResponse,
                    onChanged: (value) {
                      setState(() {
                        verbalResponse = value!;
                      });
                    },
                  ),
                ],
              ),
              h20,
              Text('Motor Response:',style: getMediumStyle(color: ColorManager.black),),
              h10,
              Text('The patient\'s ability to move and respond to commands or stimuli. This assesses their motor function and neurological status.',style: getRegularStyle(color: ColorManager.black,fontSize: 18),),
              h10,
              Column(
                children: [
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Obeys commands'),
                    value: 6,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Localises to pain'),
                    value: 5,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Withdraws to pain'),
                    value: 4,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Abnormal flexion response'),
                    value: 3,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Abnormal extension response'),
                    value: 2,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('No response'),
                    value: 1,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                  RadioListTile<int>(
                    tileColor: ColorManager.dotGrey.withOpacity(0.3),
                    title: Text('Not testable'),
                    value: 0,
                    groupValue: motorResponse,
                    onChanged: (value) {
                      setState(() {
                        motorResponse = value!;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryDark
                  ),
                  onPressed: () {
                    // Calculate and display GCS score based on user selections
                    int gcsScore = eyeResponse + verbalResponse + motorResponse;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('GCS Score'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total GCS Score: $gcsScore [E$eyeResponse, V$verbalResponse, M$motorResponse]',style: getMediumStyle(color: ColorManager.black,fontSize: 18),),
                              h20,
                              Text('Here\'s a breakdown of what each total GCS score typically indicates:'),
                              h10,
                              Text('1. GCS Score 3-8 (Severe Injury): A low GCS score in this range indicates severe brain injury or impairment of consciousness. Patients may be unresponsive or only show minimal responses to stimuli.'),
                              h10,
                              Text('2. GCS Score 9-12 (Moderate Injury): Patients with GCS scores in this range have a moderate level of impairment but are still able to respond to stimuli and communicate to some extent.'),
                              h10,
                              Text('3. GCS Score 13-15 (Mild Injury): Patients with GCS scores in this range have a mild impairment of consciousness or neurological functioning. They are typically alert and oriented, and their responses are relatively normal.')
                            ],
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Calculate', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
