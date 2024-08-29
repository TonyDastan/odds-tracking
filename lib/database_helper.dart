import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'model/OddEntry.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'odds_tracker.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE odds(id INTEGER PRIMARY KEY AUTOINCREMENT, odd REAL, time TEXT)',
        );
        print('Database Created');
      },
      onOpen: (db) {
        print('Database Opened');
      },
    );
  }

  Future<int> insertOdd(OddEntry oddEntry) async {
    try {
      Database db = await database;
      int result = await db.insert('odds', oddEntry.toMap());
      print('Inserted Odd: ${oddEntry.odd}');
      return result;
    } catch (e) {
      print('Error inserting odd: $e');
      return -1;
    }
  }

  Future<List<OddEntry>> getOdds() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('odds', orderBy: "id DESC");
    return List.generate(maps.length, (i) {
      return OddEntry(
        maps[i]['odd'],
        DateTime.parse(maps[i]['time']),
      );
    });
  }

  Future<int> deleteAllOdds() async {
    Database db = await database;
    return await db.delete('odds');
  }

  Future<int> deleteOdd(int id) async {
    Database db = await database;
    return await db.delete('odds', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    Database db = await database;
    db.close();
  }
}
