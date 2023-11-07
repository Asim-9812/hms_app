import 'package:dropdown_text_search/dropdown_text_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_app/src/core/resources/color_manager.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {

  TextEditingController _usernameController = TextEditingController();

  double overlayHeight = 0; // Initialize overlayHeight to 0

  bool elevate = true;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevate ? 30 : 0,
            backgroundColor: ColorManager.primary,

          ),
          onPressed: (){
            setState(() {
              elevate = !elevate;
            });
          },
          child: Text('Pressing',style: TextStyle(
            color: ColorManager.white
          ),),
        ),
      )
    );
  }
}
