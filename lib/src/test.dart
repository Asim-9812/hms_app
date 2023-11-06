import 'package:dropdown_text_search/dropdown_text_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {

  TextEditingController _usernameController = TextEditingController();

  double overlayHeight = 0; // Initialize overlayHeight to 0

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(30),
        child: AutofillGroup(
            child:Column(
              children: [

                TextFormField(
                  autofillHints: [AutofillHints.email],

                  decoration: InputDecoration(
                      hintText: "Username"
                  ),
                ),

                TextField(
                  obscureText: true,
                  autofillHints: [AutofillHints.password],
                  decoration: InputDecoration(
                      hintText: "Password"
                  ),
                ),

                ElevatedButton(
                    onPressed: (){
                      //--- trigger Password Save
                      TextInput.finishAutofillContext();

                      //--- OR ----

                    },
                    child:Text("Log In")
                )
              ],
            )
        ),
      ),
    );
  }
}
