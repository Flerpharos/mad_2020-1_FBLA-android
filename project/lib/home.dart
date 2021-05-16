import 'dart:html';

import "package:flutter/material.dart";

void main() {
  runApp(Homepage);
}

class Homepage extends StatelessWidget {
  const Homepage();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Mainview(),
    );
  }
}

class Profile {
  const Profile({ String this.name, this.description, this.age, this.imageUrl});

  final String name;
  final String description;
  final int age;
  final String imageURL;
}

class Mainview extends StatelessWidget {
  const Mainview({Key key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(

    );
  }
  
}