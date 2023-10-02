import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medical_app/src/core/resources/value_manager.dart';

import '../model/calorie_model.dart';
class UserProfileForm extends StatefulWidget {
  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController goalWeightController = TextEditingController();
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            h100,
            if (selectedDate != null)
              Text("Selected Date: ${selectedDate!.toLocal()}"),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text('Select Date'),
            ),
            TextFormField(
              controller: userIdController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'User ID'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'User ID is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Age'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Age is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Weight'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Weight is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Height'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Height is required';
                }
                return null;
              },
            ),
            TextFormField(
              controller: goalWeightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Goal Weight'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Goal Weight is required';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate() && selectedDate != null) {
                  final userProfile = UserProfileModel(
                    date: selectedDate!,
                    userId: userIdController.text,
                    username: usernameController.text,
                    age: int.parse(ageController.text),
                    weight: double.parse(weightController.text),
                    height: double.parse(heightController.text),
                    goalWeight: double.parse(goalWeightController.text),
                    deadline: selectedDate!,
                  );

                  // Save the UserProfileModel to Hive
                  final box = Hive.box<UserProfileModel>('user_profile');
                  box.put('user_profile', userProfile);

                  // Optionally, navigate to another screen or perform other actions
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    ))!;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}