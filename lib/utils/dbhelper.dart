import 'dart:io';
import 'package:flutter/services.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/models/Notes.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';
import "package:path/path.dart";

class DataBaseHelper {
  static DataBaseHelper _dataBaseHelper;
  static Database _dataBase;

  DataBaseHelper._internal();

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._internal();
      return _dataBaseHelper;
    } else {
      return _dataBaseHelper;
    }
  }

  Future<Database> _getDataBase() async {
    if (_dataBase == null) {
      _dataBase = await _initializeDatabase();
      return _dataBase;
    } else {
      return _dataBase;
    }
  }

  Future<Database> _initializeDatabase() async {
    var lock = Lock();
    Database _db;
    if (_db == null) {
      await lock.synchronized(() async {
        var databasesPath = await getDatabasesPath();
        print(databasesPath);
        var path = join(databasesPath, "appDB.db");
        var file = new File(path);

        if (!await file.exists()) {
          ByteData data =
              await rootBundle.load(join("assets", "mynotesapp.db"));
          List<int> bytes =
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
          await new File(path).writeAsBytesSync(bytes);
        }
        _db = await openDatabase(path);
      });
    }
    return _db;
  }

  Future<List<Map<String, dynamic>>> fetchCategory() async {
    var db = await _getDataBase();
    var result = await db.query("category");
    return result;
  }

  Future<int> createCategory(Category category) async {
    var db = await _getDataBase();
    var result = await db.insert("category", category.toMap());
    return result;
  }

  Future<int> updateCategory(Category category) async {
    var db = await _getDataBase();
    var result = await db.update("category", category.toMap(),
        where: 'catID = ?', whereArgs: [category.ID]);
    return result;
  }

  Future<int> deleteCategory(int catID) async {
    var db = await _getDataBase();
    var result =
        await db.delete("category", where: "catID = ?", whereArgs: [catID]);
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchNotes() async {
    var db = await _getDataBase();
    var result = await db.rawQuery("SELECT * FROM notes inner join category on notes.catID=category.catID order by notID Desc");
    return result;
  }
  Future<List<Category>> fetchfromclist ()async{
    var list=await fetchCategory();
    var clist=List<Category>();
    for(Map map in list){
      clist.add(Category.fromMap(map));
    }
    return clist;
  }
  Future<List<Notes>> fetchfromlist ()async{
    var list=await fetchNotes();
    var nlist=List<Notes>();
    for(Map map in list){
        nlist.add(Notes.fromMap(map));
    }
    return nlist;
  }

  Future<int> createNotes(Notes notes) async {
    var db = await _getDataBase();
    var result = await db.insert("notes", notes.toMap());
    return result;
  }

  Future<int> updateNotes(Notes notes) async {
    var db = await _getDataBase();
    var result = await db.update("notes", notes.toMap(),
        where: 'notID = ?', whereArgs: [notes.ID]);
    return result;
  }

  Future<int> deleteNotes(int notID) async {
    var db = await _getDataBase();
    var result =
        await db.delete("notes", where: "notID = ?", whereArgs: [notID]);
    return result;
  }

  String dateFormat(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    Duration oneWeek = new Duration(days: 7);
    String month;
    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylül";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
    }
    Duration difference = today.difference(tm);
    if (difference.compareTo(oneDay) < 1) {
      return "bugün";
    } else if (difference.compareTo(twoDay) < 2) {
      return "dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "pazartesi";
        case 2:
          return "salı";
        case 3:
          return "çarşamba";
        case 4:
          return "perşembe";
        case 5:
          return "cuma";
        case 6:
          return "cumartesi";
        case 7:
          return "pazar";
      }
    } else if (tm.year == today.year) {
      return "${tm.day} $month";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
    return "";
  }
}
