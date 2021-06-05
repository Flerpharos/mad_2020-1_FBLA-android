import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ProfileView()
      ),
      title: "Example",
    );
  }
}

// Testing equipment temporary
void main() {
  runApp(Home());
}

//TEMPORARY ^^^^^^
class ProfileList extends StatefulWidget {
  const ProfileList({Key? key}) : super(key: key);
  @override
  State<ProfileList> createState() => _ProfileList();
}

class _ProfileList extends State<ProfileList> {
  // Widget for List of Profiles //
  dynamic getProfileData(String field) {}
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8), // Placeholder from documentation
      children: <Widget>[
        Container(
          height: 100,
          color: Colors.white,
          child: Row(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Image will go here!"),
                // TODO: Add way to get images into here from imageURL
              ),
              Align(
                alignment: Alignment(0.5, 0.5),
                child: Text("Test Name"),
                // TODO: Add way to get name from class or firebase and put it here
              ),
              Center(
                child: Text("Test Bio"),
                // TODO: Add way to get bio/shortened description and put it here
              )
            ]
          )
        ),
      ],
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);
  @override
  // Widget for viewing Profiles in-depth //
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Name:'

                ),
              ]
            ),
            Row(
              children: [
                Text(
                  'Bio:'

                ),
              ]
            ),
            Row(
               children: [
                Text(
                  'Description:'

                ),
              ]
            ),
            Row(
               children: [
                Text(
                  'Age:'

                ),
              ]
            ),
            Row(
               children: [
                Text(
                  'Phone Number:'

                ),
              ]
            ),
            Row(
              children: [
                Text(
                  'Email:'

                ),
              ]
            ),
          ]
        ),
    );
  }
}

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEdit();
}


// TODO: Add info from Firebase //

/*
            Column(
              children: [
                ListView(
                  // Sliders for showing Email, phone#, etc. //
                  children: values.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: values[key],
                        onChanged: (bool value) {
                          setState(() {
                            values[key] = value;
                          });
                        },
                      );
                  }).toList(),
                )
              ]
            )
*/

class _ProfileEdit extends State<ProfileEdit> {
  void changeProfileData(String field, dynamic data) {}
  final _formkey = GlobalKey<FormBuilderState>();
  dynamic getProfileData(String field) {}
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _formkey,
      child: FormBuilder(
        child: Column(
          children: [
            FormBuilderTextField(
              name: "Name",
                decoration: InputDecoration(
                  labelText: "Enter your Name.",
                ),
              ),
            FormBuilderTextField(
              name: "Bio",
              decoration: InputDecoration(
                labelText: "Enter Short Description or Bio of yourself.",
              ),
            ),
            FormBuilderTextField(
              name: "Description",
              decoration: InputDecoration(
                labelText: "Enter a Description of yourself.",
              ),
            ),
            FormBuilderTextField(
              name: "Age",
              decoration: InputDecoration(
                labelText: "Enter your Age (Optional, can be disabled).",
              ),
            ),
            FormBuilderTextField(
              name: "PhoneNum",
              decoration: InputDecoration(
                labelText: "Enter a Phone Number for others to reach you (Optional, can be disabled).",
              ),
            ),
            FormBuilderTextField(
              name: "Email",
              decoration: InputDecoration(
                labelText: "Enter an Email that can be utilized by others to contact you (can be disabled).",
              ),
            ),
            ElevatedButton(
              onPressed: () {
                changeProfileData("Name", _formkey.currentState!.fields["Name"]!.value);
                changeProfileData("Bio", _formkey.currentState!.fields["Bio"]!.value);
                changeProfileData("Description", _formkey.currentState!.fields["Description"]!.value);
                changeProfileData("Age", _formkey.currentState!.fields["Age"]!.value);
                changeProfileData("Phone Number", _formkey.currentState!.fields["PhoneNum"]!.value);
                changeProfileData("Email", _formkey.currentState!.fields["Email"]!.value);
              },
                child: Text("Submit"),
            ),
          ],
        )
      )
    );
  }
}

  Map<String, bool> values = {
    'email': false,
    'phone': false,
    'age': false,
  };