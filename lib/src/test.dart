import 'package:dropdown_text_search/dropdown_text_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {

  List<String> usernames = ['Username','ram','shyam','hari'];
  TextEditingController _usernameController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              width: 250,
              child: DropdownTextSearch(
                onChange: (val){
                  print(val);
                  _usernameController.text = val;
                },
                noItemFoundText: "Invalid Search",
                controller: _usernameController,
                overlayHeight: 300,
                items: usernames,
                filterFnc: (String a,String b){
                  return a.toLowerCase().startsWith(b.toLowerCase());
                },
              )
          )
        ],
      ),
    );
  }
}
