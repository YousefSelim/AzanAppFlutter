import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

Future<List<String>> getData() async{
      print("geting loc");
      Position position;
      await Permission.location.request().isGranted;
      print(await Geolocator().isLocationServiceEnabled()==true);
      if(await Geolocator().checkGeolocationPermissionStatus()==GeolocationStatus.granted)
       {
       position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
       print("Got it from gps");
       }
       else
       {
       print("unenabled");
       //Geolocator().getCurrentPosition();

       position= Position(latitude: 0,longitude: 0);
       }
      //print(position.latitude.toString());
      var now = DateTime.now();
      var formatter = DateFormat("dd-MM-yyyy");
      String nowStr = formatter.format(now);
      var out=["N/A","N/A","N/A","N/A","N/A"];
      var requestURL='http://api.aladhan.com/v1/calendar?latitude='+position.latitude.toString()+'&longitude='+position.longitude.toString()+'&method=5&school=0&month=${now.month}&year=${now.year}';
      print("Requesting : "+requestURL);
      final response =await http.get(requestURL);
      if(response.statusCode==200)
       {
         print(response.body);
         
         var js = jsonDecode(response.body);
         var data=js["data"];
         var item;
         for(item in data)
          {
           String date = item["date"]["gregorian"]["date"];
           print("now is "+nowStr);
           print(date);
           if(date==nowStr)
            {
            out[0]=item["timings"]["Fajr"];
            out[1]=item["timings"]["Dhuhr"];
            out[2]=item["timings"]["Asr"];
            out[3]=item["timings"]["Maghrib"];
            out[4]=item["timings"]["Isha"];
            }
          }
         
       } 
      return(out);
}