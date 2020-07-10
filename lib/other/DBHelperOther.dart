import 'dart:async';
import 'dart:io' as io;
import 'other_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String DATE = 'date';
  static const String SALARY = 'salary';
  static const String UP = 'up';
  static const String TABLE = 'OtherModel';
  static const String DB_NAME = 'otherModel1.db';

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $DATE varchar(50),$UP integer, $SALARY integer)");
  }

  Future<OtherModel> save(OtherModel otherModel) async {
    var dbClient = await db;
    otherModel.id = await dbClient.insert(TABLE, otherModel.toMap());
    return otherModel;
  }

  Future<List<OtherModel>> getOtherModels() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, DATE, UP, SALARY]);
    List<OtherModel> workersDoptModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        workersDoptModels.add(OtherModel.fromMap(maps[i]));
      }
    }
    return workersDoptModels;
  }

  Future<List> allOthers() async {
    var dbClient = await db;
    return await dbClient.query(TABLE);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(OtherModel otherModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, otherModel.toMap(),
        where: '$ID = ?', whereArgs: [otherModel.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
