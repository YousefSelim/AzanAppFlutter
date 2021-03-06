import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import "./jsonget.dart";
import './azan_display_widget.dart';
import 'firstlogin.dart';
import 'test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

Future<List<String>> severData;

void main() {
runApp(FirstApp());
} 
class TestSL extends StatelessWidget {
  //const TestSL({Key key}) : super(key: key);
   
  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    severData=getData();
SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    return MaterialApp(
    title: 'Fetch Data Example',
    
    theme: ThemeData(
        primarySwatch: Colors.green, backgroundColor: Colors.purple),
    
    home: Container(
      decoration: BoxDecoration(color: Colors.purple[800]
          //image: new DecorationImage(image: new AssetImage("images/bkg_img.png"))
          ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
       
          body: 
          Container(
          decoration: BoxDecoration(
            image : DecorationImage(image: AssetImage("images/bg_new.jpg"),fit: BoxFit.fill),
            
            //color: Colors.red
            ),
          child :Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                  padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                  child: Text(
                    "مواعيد الصلاة لليوم",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Arial",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      //backgroundColor: Colors.black45
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                  child: Text(
                    DateFormat("dd-MM-yyy").format(DateTime.now()).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Arial",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      //backgroundColor: Colors.black45
                    ),
                  ),
                ),
                FutureBuilder(
                  future: severData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data[0] + "00");
                      if(snapshot.data[5]=="OK")
                      {
                      //Only ok Response
                      return Container(
                        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                        padding:EdgeInsets.fromLTRB(10, 10, 0, 10) ,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                        child: Column(
                          children: <Widget>[
                            AzanDisplay("Fajr", snapshot.data[0]),
                            AzanDisplay("Duhr", snapshot.data[1]),
                            AzanDisplay("Asr", snapshot.data[2]),
                            AzanDisplay("Maghrib", snapshot.data[3]),
                            AzanDisplay("Isha", snapshot.data[4]),
                          ],
                        ),
                      );
                      }
                      else
                      {
                        String errMsg = "UNKNOWN ERR";
                        if(snapshot.data[5]=="No Location") errMsg ="لا يوجد بيانات موقع";
                        if(snapshot.data[5]=="Couldn't reach DB") errMsg ="حدث خطأ اثناء الوصول لقاعدة البيانات";
                        if(snapshot.data[5]=="Could't Reach API") errMsg ="تحقق من وصولك بالانترنت";
                        return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.black38),
                              child: Text(
                                "جاري تحميل بعض البيانات",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontFamily: "Arial",
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  //backgroundColor: Colors.black45
                                ),
                              ),
                            ),
                            Container(
                        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                        padding:EdgeInsets.fromLTRB(10, 10, 0, 10) ,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                          child:Column(
                              children: <Widget>[
                                AzanDisplay("Fajr", "N/A"),
                                AzanDisplay("Duhr", "N/A"),
                                AzanDisplay("Asr", "N/A"),
                                AzanDisplay("Maghrib", "N/A"),
                                AzanDisplay("Isha", "N/A"),
                              ],
                            ),
                            ),
                          ],
                        ));
                      }
                    }
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.black38),
                              child: Text(
                                "جاري تحميل بعض البيانات",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Arial",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  //backgroundColor: Colors.black45
                                ),
                              ),
                            ),
                            Container(
                        margin: EdgeInsets.fromLTRB(30, 20, 30, 10),
                        padding:EdgeInsets.fromLTRB(10, 10, 0, 10) ,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.all(Radius.circular(20))
                        ),
                          child:Column(
                              children: <Widget>[
                                AzanDisplay("Fajr", "N/A"),
                                AzanDisplay("Duhr", "N/A"),
                                AzanDisplay("Asr", "N/A"),
                                AzanDisplay("Maghrib", "N/A"),
                                AzanDisplay("Isha", "N/A"),
                              ],
                            ),
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
          )),
      ),
    ),
  );

  }
}
/*
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<List<String>> data;
  @override
  void initState() {
    super.initState();
    data = getData();
  }

  @override
  Widget build(BuildContext context) {
    return buildMaterialApp();
  }

  MaterialApp buildMaterialApp() {
    return MaterialApp(
    title: 'Fetch Data Example',
    theme: ThemeData(
        primarySwatch: Colors.green, backgroundColor: Colors.purple),
    home: Container(
      decoration: BoxDecoration(color: Colors.purple[800]
          //image: new DecorationImage(image: new AssetImage("images/bkg_img.png"))
          ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                  padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                  child: Text(
                    "مواعيد الصلاة لليوم",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Arial",
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      //backgroundColor: Colors.black45
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 2, 0, 0),
                  padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      color: Colors.black38),
                  child: Text(
                    DateFormat("dd-MM-yyy").format(DateTime.now()).toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Arial",
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      //backgroundColor: Colors.black45
                    ),
                  ),
                ),
                FutureBuilder(
                  future: data,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      print(snapshot.data[0] + "00");
                      return Container(
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                        child: Column(
                          children: <Widget>[
                            AzanDisplay("Fajr", snapshot.data[0]),
                            AzanDisplay("Duhr", snapshot.data[1]),
                            AzanDisplay("Asr", snapshot.data[2]),
                            AzanDisplay("Maghrib", snapshot.data[3]),
                            AzanDisplay("Isha", snapshot.data[4]),
                          ],
                        ),
                      );
                    }
                    return Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              padding: EdgeInsets.fromLTRB(9, 0, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  color: Colors.black38),
                              child: Text(
                                "جاري تحميل بعض البيانات",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Arial",
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  //backgroundColor: Colors.black45
                                ),
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                AzanDisplay("Fajr", "N/A"),
                                AzanDisplay("Duhr", "N/A"),
                                AzanDisplay("Asr", "N/A"),
                                AzanDisplay("Maghrib", "N/A"),
                                AzanDisplay("Isha", "N/A"),
                              ],
                            ),
                          ],
                        ));
                  },
                ),
              ],
            ),
          )),
    ),
  );
  }
}
*/