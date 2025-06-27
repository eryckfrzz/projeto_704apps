
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'recordings.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> updateRecordingId(String recordingPath, String id) async {
    try {
      final db = await database;
      await db.update(
        'recordings',
        {'id': id},
        where: 'path = ?',
        whereArgs: [recordingPath],
      );
      print('ID atualizado com sucesso para o caminho: $recordingPath');
    } catch (e) {
      print('Erro ao atualizar o ID: $e');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE recordings(id TEXT PRIMARY KEY, path TEXT, date TEXT)', // ID agora é TEXT
    );
  }

  Future<void> insertRecording(String path, String date) async {
    final db = await database;
    await db.insert(
      'recordings',
      {'path': path, 'date': date}, // Note: 'id' is not passed here. It will be updated later.
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getRecordings() async {
    final db = await database;
    return await db.query('recordings', orderBy: 'date DESC');
  }
}