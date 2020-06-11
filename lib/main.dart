import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "./jsonget.dart";

Future<Album> fetchAlbum() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/albums/1');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
class Album {
  final int userId;
  final int id;
  final String title;

  Album({this.userId, this.id, this.title});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<Album> futureAlbum;
  Future<List<String>>data;
  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
    data=getData();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[FutureBuilder<Album>(
            future: futureAlbum,
            builder: (context, snapshot) {
              if (snapshot.hasData) {

                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return 
              Column(
                children: <Widget>[
                CircularProgressIndicator(),
                //http://api.aladhan.com/v1/calendar?latitude=51.508515&longitude=-0.1254872&method=2&month=7&year=2020
                Text("--99")
                ]
                );
            },
          ),
            Text("---"),
            FutureBuilder(
              future: data,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(snapshot.hasData)
                {
                print(snapshot.data[0]+"00");
                return Text(snapshot.data[0]);
                }
                return Text("Not yet");
              },
            ),],
          
          ),
            
        ),
      ),
    );
  }
}