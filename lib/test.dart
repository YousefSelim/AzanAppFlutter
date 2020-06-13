import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'main.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
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
                    "This app needs to access your location\n Click continue to grant permisson\n Also make sure location service is on\n",
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
                          onPressed: () async {
                            SharedPreferences pf =
                                await SharedPreferences.getInstance();
                            if (pf.getDouble("lat") != null &&
                                pf.getDouble("lat") != 0.0) {
                             /* runApp(TestSL());
                              return; */ //TODO : enable in production 
                            }
                            if (await Permission.location.request().isGranted &&
                                await Geolocator().isLocationServiceEnabled() ==
                                    true) {
                              Position position = await Geolocator()
                                  .getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);
                              if (position != null) {
                                pf.setDouble("lat", position.altitude);
                                pf.setDouble("long", position.longitude);
                              }
                            } else {
                              Toast.show("Toast plugin app", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

                            }
                          })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}