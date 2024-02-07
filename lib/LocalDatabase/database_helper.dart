import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/address_model.dart';


class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(
      path,
      version: 1, // Increment the version number
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add this line
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute('DROP TABLE IF EXISTS user'); // Drop the existing table
      _onCreate(db, newVersion); // Recreate the table with new schema
    }
  }



  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE attendance (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id TEXT,
      latitude TEXT,
      longitude TEXT,
      timestamp INTEGER,
      date TEXT,
      status TEXT
    )
  ''');
  }


  Future<void> insertUserData(AttendanceDataModel userDataModel) async {
    final db = await instance.database;
    try{
      await db.insert(
        'attendance',
        {
          ...userDataModel.toMap(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,

      );
      if (kDebugMode) {
        print('data inserted succesfully !');
      }
    }catch(e){
      if (kDebugMode) {
        print('insert: '+e.toString());
      }
    }
  }

  Future<void> updateUserData(AttendanceDataModel userDataModel) async {
    final db = await instance.database;
    try {
      await db.update(
        'user',
        userDataModel.toMap(),
        where: 'id = ?',
        whereArgs: [userDataModel.id],
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
     // print('UserData updated successfully.');
    } catch (e) {
     // print('Error updating UserData: $e');
    }
  }

  Future<List<AttendanceDataModel>> getAllAttendanceData(String username) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendance',
      where: 'username = ?',
      whereArgs: [username],
    );

    return List.generate(maps.length, (i) {
      return AttendanceDataModel.fromMap(maps[i]);
    });
  }

  Future<List<Map<String, dynamic>>> getAllCurrentAttendanceData(int startOfDay, int endOfDay) async {
    final db = await instance.database;
    return await db.rawQuery(
      'SELECT * FROM attendance WHERE timestamp BETWEEN ? AND ?',
      [startOfDay, endOfDay],
    );
  }

  Future<List<AttendanceDataModel>> getEntry(String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT * FROM attendance WHERE status = ? AND date = ? ORDER BY timestamp ASC LIMIT 1',
      ['checked_in', date],
    );

    return List.generate(maps.length, (i) {
      return AttendanceDataModel.fromMap(maps[i]);
    });
  }
  Future<List<AttendanceDataModel>> getExit(String date) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM attendance WHERE status = ? AND date = ? ORDER BY timestamp DESC LIMIT 1',
        ['checked_out', date]
    );

    return List.generate(maps.length, (i) {
      return AttendanceDataModel.fromMap(maps[i]);
    });
  }

}
