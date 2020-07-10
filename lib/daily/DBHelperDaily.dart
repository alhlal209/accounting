import 'dart:async';
import 'dart:io' as io;
import 'package:accounting/daily/daily_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelperDaily {
  static Database _db;
  static const String ID = 'id';
  static const String DAY = 'day';
  static const String GRID = 'grid';
  static const String CASH = 'cash';
  static const String TABLE = 'DailyModel';
  static const String DB_NAME = 'dailyModel1.db';

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
        "CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $DAY integer, $GRID integer, $CASH integer)");
  }

  Future<DailyModel> save(DailyModel dailyModel) async {
    var dbClient = await db;
    dailyModel.id = await dbClient.insert(TABLE, dailyModel.toMap());
    return dailyModel;
  }

  Future<List<DailyModel>> getDailyModels() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, DAY, GRID, CASH]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<DailyModel> dailyModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        dailyModels.add(DailyModel.fromMap(maps[i]));
      }
    }
    return dailyModels;
  }
  Future<List> allDaily() async {
    var dbClient = await db;
    return await dbClient.query(TABLE);
  }
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> sumGrid() async {
    var dbClient = await db;
    List<Map> result =
        await dbClient.rawQuery("SELECT SUM($GRID) as total FROM $TABLE");
    return result[0]['total'];
  }

  Future<int> sumCash() async {
    var dbClient = await db;
    List<Map> result =
        await dbClient.rawQuery("SELECT SUM($CASH) as total FROM $TABLE");
    return result[0]['total'];
  }

  Future<int> update(DailyModel dailyModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, dailyModel.toMap(),
        where: '$ID = ?', whereArgs: [dailyModel.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
