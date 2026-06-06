import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/catatan.dart';

// DATABASE HELPER
class DbHelper {
  // PRIVATE CONSTRUCTOR
  DbHelper._();

  // SINGLETON
  static final DbHelper instance = DbHelper._();

  // NAMA DATABASE
  static const _dbName = 'catatan.db';

  // VERSI DATABASE
  static const _dbVersion = 1;

  // NAMA TABEL
  static const tabel = 'catatan';

  Database? _db;

  // GET DATABASE
  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }

    _db = await _openDb();

    return _db!;
  }

  // OPEN DATABASE
  Future<Database> _openDb() async {
    // PATH DATABASE
    final dbPath = await getDatabasesPath();

    final path = join(dbPath, _dbName);

    // OPEN SQLITE
    return openDatabase(
      path,

      version: _dbVersion,

      // CREATE TABLE
      onCreate: (db, version) async {
        await db.execute('''

          CREATE TABLE $tabel (

            id INTEGER PRIMARY KEY AUTOINCREMENT,

            judul TEXT NOT NULL,

            isi TEXT NOT NULL,

            kategori TEXT NOT NULL,

            dibuat_pada INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  // INSERT DATA
  Future<int> insert(Catatan catatan) async {
    final db = await database;

    return db.insert(tabel, catatan.toMap());
  }

  // GET ALL DATA
  Future<List<Catatan>> getAll() async {
    final db = await database;

    final hasil = await db.query(tabel, orderBy: 'dibuat_pada DESC');

    return hasil.map(Catatan.fromMap).toList();
  }

  // UPDATE DATA
  Future<int> update(Catatan catatan) async {
    final db = await database;

    return db.update(
      tabel,

      catatan.toMap(),

      where: 'id = ?',

      whereArgs: [catatan.id],
    );
  }

  // DELETE DATA
  Future<int> delete(int id) async {
    final db = await database;

    return db.delete(tabel, where: 'id = ?', whereArgs: [id]);
  }
}
