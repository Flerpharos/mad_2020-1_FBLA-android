import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supercharged/supercharged.dart';

class Profile {
  const Profile({this.name, this.description, this.bio, this.age, this.imageUrl});

  final String name;
  final String description;
  final String bio;
  final int age;
  final String imageURL;
}


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