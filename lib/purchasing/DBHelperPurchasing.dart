import 'dart:async';
import 'dart:io' as io;
import 'purchasing_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String DETAILS = 'details';
  static const String PRICE = 'price';
  static const String TABLE = 'PurchasingModel';
  static const String DB_NAME = 'purchasingModel.db';

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
    await db.execute("CREATE TABLE $TABLE ($ID INTEGER PRIMARY KEY, $DETAILS varchar(50), $PRICE integer)");
  }

  Future<PurchasingModel> save(PurchasingModel workersDoptModel) async {
    var dbClient = await db;
    workersDoptModel.id = await dbClient.insert(TABLE, workersDoptModel.toMap());
    return workersDoptModel;
  }

  Future<List<PurchasingModel>> getPurchasingModels() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID,DETAILS,PRICE]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<PurchasingModel> purchasingModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        purchasingModels.add(PurchasingModel.fromMap(maps[i]));
      }
    }
    return purchasingModels;
  }
  Future<List> allPurchasing() async {
    var dbClient = await db;
    return await dbClient.query(TABLE);
  }
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> update(PurchasingModel workersDoptModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, workersDoptModel.toMap(),
        where: '$ID = ?', whereArgs: [workersDoptModel.id]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}