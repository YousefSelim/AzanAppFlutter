import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:nice_button/nice_button.dart';
import 'dart:async';
import 'main.dart';
import 'package:geolocator/geolocator.dart';

void main() async {
  if(await Geolocator().checkGeolocationPermissionStatus()==GeolocationStatus.granted)
  {
    runApp(TestSL());
  }
  else
  {
  runApp(FirstApp());
  }
}

class FirstApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context)  {
    return MaterialApp(
      title: 'Salatuk',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome'),
          backgroundColor: Colors.deepPurple[500],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bkg.png"), fit: BoxFit.fill),

            //color: Colors.red
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 200, 0, 40),
              child: Column(
                children: <Widget>[
                  Container(
                      child: Text(
                    """
This app needs to access your location 
Click continue to grant permisson 
Also make sure location service is on\n""",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  )),
                  Container(
                      child: CupertinoButton(
                          child: Text(
                            "Click to continue",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          color: Colors.white,
                          onPressed: ()async {
                            if (await Permission.location.request().isGranted && await Geolocator().isLocationServiceEnabled()==true) {
                            print("hi");
                            
                            runApp(TestSL());
                            }
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    void firstInit(BuildContext con) async {}
  }
}
