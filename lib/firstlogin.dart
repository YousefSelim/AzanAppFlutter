import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';

void main() async {
  if (await Geolocator().checkGeolocationPermissionStatus() ==
      GeolocationStatus.granted) {
    runApp(TestSL());
  } else {
    runApp(FirstApp());
  }
}

class FirstPageApp extends StatefulWidget {
  FirstPageApp({Key key}) : super(key: key);

  @override
  _FirstPageAppState createState() => _FirstPageAppState();
}

class _FirstPageAppState extends State<FirstPageApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salatuk',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome To Salatuk'),
          backgroundColor: Colors.deepPurple[500],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/bg_new.jpg"), fit: BoxFit.fill),

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
                            msgToast("Getting location...");
                            SharedPreferences pf =
                                await SharedPreferences.getInstance();
                            if (pf.getDouble("lat") != null &&
                                pf.getDouble("lat") != 0.0) {
                               runApp(TestSL());
                              return;  //TODO : enable in production
                            }
                            if (await Permission.location.request().isGranted) {
                              if (await Geolocator()
                                      .isLocationServiceEnabled() ==
                                  true) {

                                Position position = await Geolocator()
                                    .getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: 20),
                                        onTimeout: () {print("timeout");return null;}
                                        );
                                if (position != null) {
                                  pf.setDouble("lat", position.altitude);
                                  pf.setDouble("long", position.longitude);
                                  runApp(TestSL());
                                  print(position.latitude);
                                }
                                else
                                {
                                  errorToast("Couldn\'t Retrieve GPS Location Now\nTry Other Options");
                                }
                              }
                              else
                              {
                                errorToast("Please Turn GPS on!");
                              }
                            } 
                            else {
                              errorToast("Please Grant GPS Permission!");
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
void errorToast(String msg) {
  print("Error Toast: "+msg);
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        backgroundRadius: 9);
  }

  void msgToast(String msg) {
    Toast.show(msg, context,
        duration: Toast.LENGTH_LONG,
        gravity: Toast.BOTTOM,
        backgroundColor: Colors.grey[400],
        textColor: Colors.black,
        backgroundRadius: 9);
  }
  
}

class FirstApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        body: FirstPageApp(),
      ),
    );
  }
}
