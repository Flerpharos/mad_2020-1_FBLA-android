// Christoph you just need to animate the containers and put them together like you did in Trampoline and add the content you want in the gray areas, I didn't know how to do them and couldn't find anything online to help me.
// Christoph you just need to animate the containers and put them together like you did in Trampoline and add the content you want in the gray areas, I didn't know how to do them and couldn't find anything online to help me.

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
                title: Text('SixDegrees'),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.account_box_rounded,
                      color: Colors.white,
                    ),

                    onPressed: () {
                      // do something
                    },
                  )
                ],

                backgroundColor: Colors.red,
                centerTitle: true),
            body: Column(
              //ROW 1
              children: [
                Container(
                  color: Colors.orange,
                  width: 1000,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  margin: EdgeInsets.all(25.0),
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('Recommended Organizations',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25.0,)),


                  ),
                ),


                Container(
                    color: Colors.grey,
                    width: 400,
                    height: 300,
                    margin: EdgeInsets.all(15.0),
                    child: Text('Content for the recommended Organizations'),
                    alignment: Alignment.topLeft
                ),



                Container(
                  color: Colors.blue,
                  width: 1000,
                  height: 100,
                  margin: EdgeInsets.all(25.0),
                  child: Text('People who have similar intrests to you',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 25.0)),

                ),



                Container(
                  color: Colors.grey,
                  width: 400,
                  height: 300,
                  margin: EdgeInsets.all(15.0),
                  child: Text('Content for the recommended Organizations'),

                ),

              ],
            )
        )
    );
  }
}