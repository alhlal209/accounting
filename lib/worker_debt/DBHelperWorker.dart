import 'dart:async';
import 'dart:io' as io;
import 'package:accounting/worker_debt/take_model.dart';

import 'workers_dept_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DBHelper {
  static Database _db;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String SALARY = 'salary';
  static const String TAKEFROM = 'takefrom';
  static const String REMAIN = 'remain';
  static const String TABLE = 'WorkersDoptModel';

  static const String ID1 = 'idtake';
  static const String QUANTITY = 'quantity';
  static const String DATE = 'date';
  static const String FOREIGNKEY = 'foreignkey';
  static const String TABLE1 = 'TAKEFROMSALARY';

  static const String DB_NAME = 'workersDoptModel1.db';

// CREATE TABLE `WorkersDoptModel` (
// 	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
// 	`name`	TEXT,
// 	`salary`	INTEGER,
// 	`takefrom`	INTEGER,
// 	`remain`	INTEGER
// );

// CREATE TABLE TAKEFROMSALARY (
//             idtake INTEGER PRIMARY KEY,
//              quantity integer,
//             date text,
//             foreignkey integer,
//             FOREIGN KEY (foreignkey) REFERENCES WorkersDoptModel(id)
//             )

// select * from TAKEFROMSALARY where foreignkey = user_id


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
    var db = await openDatabase(path, version: 2, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE `WorkersDoptModel` (
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT,
	`salary`	INTEGER,
	`takefrom`	INTEGER,
	`remain`	INTEGER
);

             ''');
    await db.execute('''
        CREATE TABLE TAKEFROMSALARY (
            idtake INTEGER PRIMARY KEY,
             quantity integer,
            date text,
            foreignkey integer,
            FOREIGN KEY (foreignkey) REFERENCES WorkersDoptModel(id)
            )
            '''
    );
//    await db.execute('''
//        ALTER TABLE $TABLE1 add constrain FOREIGN KEY ($FOREIGNKEY) REFERENCES $TABLE($ID)
//            '''
//    );
  }
//  FOREIGN KEY ($FOREIGNKEY) REFERENCES $TABLE($ID)
  Future<WorkersDoptModel> save(WorkersDoptModel workersDoptModel) async {
    var dbClient = await db;
    workersDoptModel.id =
        await dbClient.insert(TABLE, workersDoptModel.toMap());
    return workersDoptModel;
  }

  Future<TakeModel> saveDetails(TakeModel takeModel) async {
    var dbClient = await db;
    takeModel.idtake = await dbClient.insert(TABLE1, takeModel.toMap());
    return takeModel;
  }

  Future<List<WorkersDoptModel>> getWorkersDoptModels() async {
    var dbClient = await db;
    List<Map> maps =
        await dbClient.query(TABLE, columns: [ID, NAME, SALARY, TAKEFROM,REMAIN]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<WorkersDoptModel> workersDoptModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        workersDoptModels.add(WorkersDoptModel.fromMap(maps[i]));
      }
    }
    return workersDoptModels;
  }

  Future<List<TakeModel>> getWorkerDetails(var workerid) async {
    var dbClient = await db;
    List<Map> maps = await dbClient
        .query(TABLE1, columns: [ID1,QUANTITY, DATE, FOREIGNKEY ],where: '$FOREIGNKEY = ?', whereArgs: [workerid]);
    List<TakeModel> takeModels = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        takeModels.add(TakeModel.fromMap(maps[i]));
      }
    }
    return takeModels;
  }

  Future<List> allWorkers() async {
    var dbClient = await db;
    return await dbClient.query(TABLE);
  }

  Future<List> allDetails() async {
    var dbClient = await db;
    return await dbClient.query(TABLE1);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }

  Future<int> deleteDetail(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE1, where: '$ID1 = ?', whereArgs: [id]);
  }

  Future<int> update(WorkersDoptModel workersDoptModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, workersDoptModel.toMap(),
        where: '$ID = ?', whereArgs: [workersDoptModel.id]);
  }
  Future<int> sumTake() async {
    var dbClient = await db;
    List<Map> result =
    await dbClient.rawQuery("SELECT SUM($QUANTITY) as total FROM $TABLE1");
    return result[0]['total'];
  }

  Future<int> foreignColumn() async {
    var dbClient = await db;
    List<Map> result =
    await dbClient.rawQuery("SELECT $TABLE.column as x"
        " $TABLE.column from $TABLE"
        " join table2 when "
        "($TABLE.foreign_column==$TABLE.$FOREIGNKEY)");
    return result[0]['x'];
  }
  Future<int> updateDetails(TakeModel takeModel) async {
    var dbClient = await db;
    return await dbClient.update(TABLE1, takeModel.toMap(),
        where: '$ID1 = ?', whereArgs: [takeModel.idtake]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
