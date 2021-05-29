import 'dart:html';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

// Testing equipment temporary
void main() {
  runApp( const TestApp);
}

class TestApp extends StatelessWidget {
  const TestApp({Key? key}) : super(key: key);
  static const String _title = 'Profile Test';
  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: Center(
          child: ProfileView,
        )
      )
    )
  }
}

//TEMPORARY ^^^^^^

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileView();
}

class Profile {
  const Profile({this.name, this.description, this.bio, this.age, this.imageUrl});

  final String name;
  final String description;
  final String bio;
  final int age;
  final String imageURL;
}

// Widget for List of Profiles //
Widget build(BuildContext context) {
  return ListView(
    padding: const EdgeInsets.all(8), // Placeholder from documentation
    children: <Widget>[
      Container(
        height: 100,
        color: Colors.white,
        Row(
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

//TODO: Add info from Firebase//
// Widget for viewing Profiles in-depth //
<<<<<<< HEAD
class _ProfileView extends State<ProfileView> {
  Map<String, bool> values = {
    'email': false,
    'phone': false,
    'age': false,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      children: <Widget>[
        Row(
          children: [
            Column(
              children: [
                Text(
                  'Name:'

                ),
              ]
            ),
            Column(
              children: [
                Text(
                  'Bio:'

                ),
              ]
            Column(
               children: [
                Text(
                  'Description:'

                ),
              ]
            ),
            Column(
               children: [
                Text(
                  'Age:'

                ),
              ]
            ),
            Column(
               children: [
                Text(
                  'Phone Number:'

                ),
              ]
            ),
            Column(
              children: [
                Text(
                  'Email:'

                ),
              ]
            ),
            Column(
              children: [
                ListView(
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
                // Sliders for showing Email, phone#, etc. //
              ]
            )
        ),
      ],
    )]);
  }
}