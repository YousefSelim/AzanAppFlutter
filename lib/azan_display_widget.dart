import 'package:flutter/material.dart';
class SSS extends StatelessWidget {
 
  const SSS({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("hi"),
    );
  }
}
 class AzanDisplay extends StatelessWidget {
 String prayername ;
  String prayertime;
  AzanDisplay(this.prayername,this.prayertime);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:Alignment.center,
      margin: EdgeInsets.fromLTRB(0, 2, 0, 5),
      child: Row(
        children: <Widget>[
          Container(
            //alignment: Alignment.center,
            width: 90,
            height: 50.0,
            padding: EdgeInsets.fromLTRB(9, 13, 0, 10),
            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Text(
              prayername +":",
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Arial",
                fontSize: 18,
                fontWeight: FontWeight.bold
                
              ),
              textAlign: TextAlign.left,
              
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(left:Radius.circular(20)),
               /*border: Border(
                            left :BorderSide(width: 2,color: Colors.black,style: BorderStyle.solid),
                            right: BorderSide(width: 0,color: Colors.black,style: BorderStyle.none),
                            top: BorderSide(width: 2,color: Colors.black,style: BorderStyle.solid),
                            bottom: BorderSide(width: 2,color: Colors.black,style: BorderStyle.solid),
                             ),*/
              color: Colors.deepPurpleAccent//Color.fromARGB(170, 123, 31, 162)
              ),
            ),
            
           Container(
             
            //margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
            //padding: EdgeInsets.fromLTRB(, 0 , 0, 0),
            alignment: Alignment.center,
            width: 170,
            height: 50.0,
            child: Text(
              prayertime,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Arial"
              ),
              textAlign: TextAlign.center,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.horizontal(right :Radius.circular(8)),
              color: Colors.deepPurpleAccent
            ),
            ) 
        ],
      ),
    );
  }
}
/*
Container(
            width: 300,
            height: 30.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.redAccent,
            ),
            child:Text("Hi"),
            ),
*/