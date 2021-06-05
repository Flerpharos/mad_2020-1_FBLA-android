import 'dart:html';

import "package:flutter/material.dart";
import 'package:flutter_form_builder/flutter_form_builder.dart';

class Main extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Settings()
      ),
      title: "Testing Settings",
    );
  }
}

class Settings extends StatefulWidget {
  const Settings({Key? key}) : final(key: key);
  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      key: _formkey,
      child: FormBuilder(
        child: Column(
          children: [
            Slider(
              value: theme,
              onChanged: (newtheme) {
                setState(() => theme = newtheme); 
              },
              divisions: 4,
              label: "$theme",
            )
          ],
        )
      )
    );
  }
}