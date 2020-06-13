import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sql.dart';
import 'package:path/path.dart';
class PrayerTime {
  String date;
  String fajr, duhr, maghrib, asr, isha, hijri;
  PrayerTime(this.date, this.fajr, this.duhr, this.asr, this.maghrib, this.isha,
      this.hijri);

  Map<String, dynamic> toMap() {
    return {
      "date": date,
      "fajr": fajr,
      "duhr": duhr,
      "asr": asr,
      "maghrib": maghrib,
      "isha": isha,
      "hijri": hijri
    };
  }
}
Database database;
Future<Database> getDB() async
{
  var _database= await openDatabase(
    join(await getDatabasesPath(),"azan_timed.dp"),
    onCreate: (db,version){
      return db.execute("CREATE TABLE prayertimes(date TEXT PRIMARY KEY,fajr TEXT,duhr TEXT,asr TEXT,maghrib TEXT,isha TEXT,hijri TEXT)");
    },
    version: 1
  );
  database= _database;
  return _database;
}
Future<void> addPrayerTime(PrayerTime pt) async
{
  if(database==null)
   {
     database = await getDB();
   }
   final db = await database;
   db.insert("prayertimes", pt.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
}
Future<PrayerTime> getPrayerTime(String date) async{
if(database==null)
   {
     database = await getDB();
   }
   final db= await database;
   final List<Map<String,dynamic>> query_result=await db.query("prayertimes",
   where: "date = ? ",
   whereArgs: [date]
   );
  if (query_result!=null && query_result.length !=0)
   {
     return PrayerTime(query_result[0]["date"], query_result[0]["fajr"], query_result[0]["duhr"], query_result[0]["asr"], query_result[0]["maghrib"], query_result[0]["isha"], query_result[0]["hijri"]);
   }
   else{
     return null;
   }
}