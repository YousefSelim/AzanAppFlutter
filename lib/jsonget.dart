import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dbManagement.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firstlogin.dart';

Future<List<String>> getData() async {
  ///Check If Location is avaialble
  ///
  int timeOutDurationInSeconds = 10;
  var out = ["N/A", "N/A", "N/A", "N/A", "N/A", "Data NULL"];
  var now = DateTime.now();
  var formatter = DateFormat("dd-MM-yyyy");
  String nowStr = formatter.format(now);
  SharedPreferences pf = await SharedPreferences.getInstance();
  if (pf.getDouble("lat") == null && pf.getDouble("lat") == 0.0) {
    runApp(FirstApp());
    out[5] = "No Location";
    return out;
  }
  database = await getDB().timeout(
    Duration(seconds: timeOutDurationInSeconds),
    onTimeout: () {
      out[5] = "Couldn't reach DB";
      return null;
    },
  );
  if (database != null) {
    PrayerTime pt = await getPrayerTime(nowStr).timeout(
      Duration(seconds: timeOutDurationInSeconds),
      onTimeout: () {
        out[5] = "Couldn't reach DB";
        return null;
      },
    );
    if (pt != null) {
      out[0] = pt.fajr;
      out[1] = pt.duhr;
      out[2] = pt.asr;
      out[3] = pt.maghrib;
      out[4] = pt.isha;
      out[5] = "OK";
      return out;
    }
  }

  //print(position.latitude.toString());

  var requestURL = 'http://api.aladhan.com/v1/calendar?latitude=' +
      pf.getDouble("lat").toString() +
      '&longitude=' +
      pf.getDouble("long").toString() +
      '&method=5&school=0&month=${now.month}&year=${now.year}';
  print("Requesting : " + requestURL);
  http.Response response;
  try {
    response = await http.get(requestURL);
  } catch (e) {
    response = null;
    out[5] = "Could't Reach API";
    return out;
  }

  if (response.statusCode == 200) {
    print(response.body);
    var js = jsonDecode(response.body);
    var data = js["data"];
    var item;
    for (item in data) {
      String date = item["date"]["gregorian"]["date"];
      addPrayerTime(PrayerTime(
          date,
          item["timings"]["Fajr"],
          item["timings"]["Dhuhr"],
          item["timings"]["Asr"],
          item["timings"]["Maghrib"],
          item["timings"]["Isha"],
          date));
      print("now is " + nowStr);
      print(date);
      if (date == nowStr) {
        out[0] = item["timings"]["Fajr"];
        out[1] = item["timings"]["Dhuhr"];
        out[2] = item["timings"]["Asr"];
        out[3] = item["timings"]["Maghrib"];
        out[4] = item["timings"]["Isha"];
        out[5] = "OK";
      }
    }
  } else {
    out[5] = "Could't Reach API";
    return out;
  }
  return (out);
}
