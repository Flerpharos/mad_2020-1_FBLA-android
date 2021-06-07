// Messaging is pretty bare bones I just made input text and a icon.



import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Messages',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Message Layout'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: 300),
          child: TextField(
            decoration: InputDecoration(
                hintText: 'Enter Text',
                icon: Icon(Icons.photo),
                child: const Align(
                  alignment: Alignment.bottomRight,
                  border: OutlineInputBorder(),

                )
            ),
          ),
        ),
      ),
    );
  }


}