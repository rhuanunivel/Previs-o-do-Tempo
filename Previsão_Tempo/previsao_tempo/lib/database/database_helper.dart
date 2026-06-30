import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/localizacao.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('previsao.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE localizacao(
        id INTEGER PRIMARY KEY,
        latitude REAL,
        longitude REAL
      )
    ''');
  }

  Future<void> salvarLocalizacao(double latitude, double longitude) async {
    final db = await instance.database;

    final resultado = await db.query("localizacao", where: "id = 1");

    if (resultado.isEmpty) {
      await db.insert("localizacao", {
        "id": 1,
        "latitude": latitude,
        "longitude": longitude,
      });
    } else {
      await db.update(
        "localizacao",
        {"latitude": latitude, "longitude": longitude},
        where: "id = ?",
        whereArgs: [1],
      );
    }
  }

  Future<Localizacao?> buscarLocalizacao() async {
    final db = await instance.database;

    final resultado = await db.query("localizacao", where: "id = 1");

    if (resultado.isNotEmpty) {
      return Localizacao.fromMap(resultado.first);
    }

    return null;
  }
}
