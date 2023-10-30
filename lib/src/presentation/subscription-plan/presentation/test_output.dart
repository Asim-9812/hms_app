import 'package:flutter/material.dart';

import '../../register/domain/register_service.dart';


class SomeOtherClass extends StatelessWidget {

  final Map<String,dynamic> outputValue ;
  SomeOtherClass({required this.outputValue});
  // Create an instance of RegisterService
  final RegisterService registerService = RegisterService();

  // A function that uses the outputValue
  void useOutputValue() {

    // Use the outputValue here
    (outputValue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Some Other Class'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform some action that triggers the use of outputValue
            useOutputValue();
          },
          child: Text('Use Output Value'),
        ),
      ),
    );
  }
}
