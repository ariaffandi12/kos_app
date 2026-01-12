import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:kos_app/models/user.dart';
import 'package:kos_app/models/room.dart';
import 'package:kos_app/models/bill.dart';
import 'package:kos_app/models/complains.dart';
import 'package:kos_app/models/chat.dart';



class DBService {
  static final DBService instance = DBService._init();
  static Database? _database;

  DBService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kos_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    // 1. Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT NOT NULL,
        roomId TEXT
      )
    ''');

    // 2. Rooms
    await db.execute('''
      CREATE TABLE rooms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        description TEXT,
        status TEXT NOT NULL,
        imagePath TEXT
      )
    ''');

    // 3. Bills
    await db.execute('''
      CREATE TABLE bills (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenantId TEXT NOT NULL,
        month TEXT NOT NULL,
        amount REAL NOT NULL,
        status TEXT NOT NULL,
        proofImage TEXT
      )
    ''');

    // 4. Complaints
    await db.execute('''
      CREATE TABLE complaints (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tenantId TEXT NOT NULL,
        description TEXT NOT NULL,
        image TEXT,
        status TEXT NOT NULL
      )
    ''');

    // 5. Chats
    await db.execute('''
      CREATE TABLE chats (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        senderId TEXT NOT NULL,
        receiverId TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');

    // Seed Default Owner
    await db.insert('users', User(
      name: 'Pak Owner',
      email: 'admin@kos.com',
      password: 'admin',
      role: 'owner'
    ).toMap());
  }
}