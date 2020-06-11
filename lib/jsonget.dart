import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

Future<List<String>> getData() async{
      Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var now = DateTime.now();
      var formatter = DateFormat("dd-MM-yyyy");
      String now_str = formatter.format(now);
      var out=["N/A","N/A","N/A","N/A","N/A"];
      var request_url='http://api.aladhan.com/v1/calendar?latitude='+position.latitude.toString()+'&longitude='+position.longitude.toString()+'&method=5&school=0&month=${now.month}&year=${now.year}';
      print("Requesting : "+request_url);
      final response =await http.get(request_url);
      if(response.statusCode==200)
       {
         print(response.body);
         
         var js = jsonDecode(response.body);
         var data=js["data"];
         var item;
         for(item in data)
          {
           String date = item["date"]["gregorian"]["date"];
           print("now is "+now_str);
           print(date);
           if(date==now_str)
            {
            out[0]=item["timings"]["Asr"];
            out[1]=item["timings"]["Fajr"];
            }
          }
         
       } 
      return(out);
}