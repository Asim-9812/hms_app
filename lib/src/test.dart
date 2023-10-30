import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestPage extends ConsumerStatefulWidget {
  const TestPage({Key? key});

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends ConsumerState<TestPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Text('Test')),
    );
  }
}
