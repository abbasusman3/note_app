import 'package:path/path.dart'; // Handles database path
import 'package:sqflite/sqflite.dart'; // SQLite package for mobile platforms
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqlite_common_ffi/sqflite_ffi.dart'; // SQLite package for desktop platforms
import 'dart:io'; // Needed for platform checks

import 'model_class.dart'; // Your ModelStudent class

const String tableName = "students"; // Define table name
const String columnId = "id";
const String columnName = "name";
const String columnPhoneNumber = "phoneNumber";
const String columnCity = "city";

class DataStudent {
  static DataStudent? _dataStudent; // Singleton instance
  static Database? _database; // Holds the database reference

  DataStudent._createInstance(); // Private constructor for singleton

  factory DataStudent() {
    // Factory constructor to return the singleton instance
    if (_dataStudent == null) {
      _dataStudent = DataStudent._createInstance();
    }
    return _dataStudent!;
  }

  Future<Database> get database async {
    // Check if the database is already initialized
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Database? db;
    try {
      // Initialize FFI for desktop platforms
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      // Get the correct path to store the database file
      String path = join(await getDatabasesPath(), 'student.db');
      print("Database path: $path");

      String createTable = '''
      CREATE TABLE $tableName(
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT,
        $columnPhoneNumber TEXT,
        $columnCity TEXT
      )''';

      // Open or create the database
      db = await openDatabase(
        path,
        version: 1,
        onCreate: (Database database, int version) async {
          await database.execute(createTable);
        },
      );
    } catch (e) {
      print("Error initializing database: ${e.toString()}");
    }
    return db!;
  }

  Future<bool> addRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database; // Ensure database is initialized
      int count = await db.insert(tableName, modelStudent.toMap());
      print("Record added successfully, ID: $count");
      return count > 0;
    } catch (e) {
      print("Error adding record: ${e.toString()}");
      return false;
    }
  }

  Future<List<ModelStudent>> getAllRecords() async {
    List<ModelStudent> listStudents = [];
    try {
      Database db = await database; // Ensure database is initialized
      List<Map<String, dynamic>> records = await db.query(tableName);
      for (var record in records) {
        listStudents.add(ModelStudent.fromMap(record));
      }
      return listStudents;
    } catch (e) {
      print("Error fetching records: ${e.toString()}");
      return listStudents;
    }
  }

  Future<bool> updateRecord(ModelStudent modelStudent) async {
    try {
      Database db = await database; // Ensure database is initialized
      int count = await db.update(
        tableName,
        modelStudent.toMap(),
        where: "$columnId = ?", // Safe way to filter by ID
        whereArgs: [modelStudent.id],
      );
      print("Records updated: $count");
      return count > 0;
    } catch (e) {
      print("Error updating record: ${e.toString()}");
      return false;
    }
  }

  Future<bool> deleteRecord(int id) async {
    try {
      Database db = await database; // Ensure database is initialized
      int count = await db.delete(
        tableName,
        where: "$columnId = ?",
        whereArgs: [id],
      );
      print("Records deleted: $count");
      return count > 0;
    } catch (e) {
      print("Error deleting record: ${e.toString()}");
      return false;
    }
  }
}
